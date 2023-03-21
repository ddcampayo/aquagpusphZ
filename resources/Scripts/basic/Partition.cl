/** @file
 * @brief Z computation. Similar to Shepard renormalization factor computation.
 */

#ifndef EXCLUDED_PARTICLE
    /** @brief Excluded particles from Z computation. 
     * 
     * By default all the particles are included. Therefore it is strongly
     * recommended to redefine this macro to specify whether the fluid
     * particles (imove != 1) or the solid particles (imove != 2) are used 
     * @note Redefining this macro this OpenCL script can be recicled
     * @remarks Z ever computed at the
     * boundary elements and sensors (imove <= 0)
     */
    #define EXCLUDED_PARTICLE(index) imove[index] >= 3
#endif

#if defined(LOCAL_MEM_SIZE) && defined(NO_LOCAL_MEM)
    #error NO_LOCAL_MEM has been set.
#endif

#include "resources/Scripts/types/types.h"
#include "resources/Scripts/KernelFunctions/Kernel.h"

/** @brief Z computation.
 *
 * \f[  Z_j=  \sum_i W_{ij}  \f]
 *
 * fluid extension particles are not taken
 * into account.
 *
 * @param imove Moving flags.
 *   - imove > 0 for regular fluid particles.
 *   - imove = 0 for sensors.
 *   - imove < 0 for boundary elements/particles.
 * @param r Position \f$ \mathbf{r} \f$.
 * @param rho Density \f$ \rho \f$.
 * @param m Mass \f$ m \f$.
 * @param partition Z term
 * \f$ \gamma(\mathbf{x}) = \int_{\Omega}
 *     W(\mathbf{y} - \mathbf{x}) \mathrm{d}\mathbf{y} \f$.
 * @param icell Cell where each particle is located.
 * @param ihoc Head of chain for each cell (first particle found).
 * @param N Number of particles.
 * @param n_cells Number of cells in each direction
 */
__kernel void entry(const __global unsigned int* iset,
		    const __global int* imove,
                    const __global vec* r,
                    const __global float* rho,
                    const __global float* refd,
                    const __global float* m,
                    const __global float* p,
                    __global float* partition,
                    // Link-list data
                    const __global uint *icell,
                    const __global uint *ihoc,
                    // Simulation data
                    uint N,
                    float cs,
                    uivec4 n_cells)
{
    const uint i = get_global_id(0);
    const uint it = get_local_id(0);
    if(i >= N)
        return;
    if((imove[i] < -3) || ((imove[i] > 0) && (EXCLUDED_PARTICLE(i))))
        return;

    const vec_xyz r_i = r[i].XYZ;

    // Initialize the output
    #ifndef LOCAL_MEM_SIZE
        #define _PARTITION_ partition[i]
    #else
        #define _PARTITION_ partition_l[it]
        __local float partition_l[LOCAL_MEM_SIZE];
        _PARTITION_ = 0.f;
    #endif

    BEGIN_LOOP_OVER_NEIGHS(){
//        if(EXCLUDED_PARTICLE(j)){
//            j++;
//            continue;
//        }

        const vec_xyz r_ij = r[j].XYZ - r_i;
        const float q = length(r_ij) / H;
        if(q >= SUPPORT)
        {
            j++;
            continue;
        }

        {
//          _PARTITION_ += kernelW(q)  * exp( ( p[j] - p[i] ) / ( cs * cs ) ) * CONW  ; 
//            _PARTITION_ += kernelW(q)  * exp( ( rho[j] - rho[i] ) / refd[iset[j]] ) * CONW ;
//            _PARTITION_ += kernelW(q)  * exp( p[j] / ( cs * cs)  ) * CONW  ;
            _PARTITION_ += kernelW(q)  * exp( rho[j] / refd[iset[j]] ) * CONW ;
//            _PARTITION_ += kernelW(q)  * exp( rho[j] / refd[iset[j]] ) ;
        }
    }END_LOOP_OVER_NEIGHS()


    #ifdef LOCAL_MEM_SIZE
	partition[i] = _PARTITION_;
    #endif
}
