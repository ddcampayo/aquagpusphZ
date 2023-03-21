/*
 *  This file is part of AQUAgpusph, a free CFD program based on SPH.
 *  Copyright (C) 2012  Jose Luis Cercos Pita <jl.cercos@upm.es>
 *
 *  AQUAgpusph is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  AQUAgpusph is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with AQUAgpusph.  If not, see <http://www.gnu.org/licenses/>.
 */

/** @file
 * @brief Fluid particles interactions computation.
 */

#if defined(LOCAL_MEM_SIZE) && defined(NO_LOCAL_MEM)
    #error NO_LOCAL_MEM has been set.
#endif

#include "resources/Scripts/types/types.h"
#include "resources/Scripts/KernelFunctions/Kernel.h"

#if __LAP_FORMULATION__ == __LAP_MONAGHAN__
    #ifndef HAVE_3D
        #define __CLEARY__ 8.f
    #else
        #define __CLEARY__ 10.f
    #endif
#endif

/** @brief Fluid particles interactions computation.
 *
 * Compute the differential operators involved in the numerical scheme, taking
 * into account just the fluid-fluid interactions.
 *
 * @param imove Moving flags.
 *   - imove > 0 for regular fluid particles.
 *   - imove = 0 for sensors.
 *   - imove < 0 for boundary elements/particles.
 * @param r Position \f$ \mathbf{r} \f$.
 * @param u Velocity \f$ \mathbf{u} \f$.
 * @param rho Density \f$ \rho \f$.
 * @param m Mass \f$ m \f$.
 * @param p Pressure \f$ p \f$.
 * @param Z partition functio \f$ Z \f$.
 * @param grad_p Pressure gradient \f$ \frac{\nabla p}{rho} \f$.
 * @param lap_u Velocity laplacian \f$ \frac{\Delta \mathbf{u}}{rho} \f$.
 * @param div_u Velocity divergence \f$ \rho \nabla \cdot \mathbf{u} \f$.
 * @param icell Cell where each particle is located.
 * @param ihoc Head of chain for each cell (first particle found).
 * @param N Number of particles.
 * @param n_cells Number of cells in each direction
 */
__kernel void entry(const __global int* imove,
                    const __global vec* r,
                    const __global vec* u,
                    const __global float* rho,
                    const __global float* refd,
                    const __global float* m,
                    const __global float* p,
                    const __global float* partition,
		    const __global unsigned int* iset,
                    __global vec* grad_p,
                    __global vec* lap_u,
                    __global float* div_u,
                    // Link-list data
                    const __global uint *icell,
                    const __global uint *ihoc,
                    // Simulation data
                    uint N,
                    float cs,
		    float p0,
                    uivec4 n_cells)
{
    const uint i = get_global_id(0);
    const uint it = get_local_id(0);
    if(i >= N)
        return;
    if(imove[i] != 1){
        return;
    }

    const vec_xyz r_i = r[i].XYZ;
    const vec_xyz u_i = u[i].XYZ;
    const float p_i = p[i];
 //   const float fug_i = exp( p_i / (cs * cs) );
    const float fug_i = exp( rho[i] / refd[iset[i]] );
//    const float p_i =  p0 + cs * cs * (rho[i] - refd[iset[i]]); //  p0+cs*cs*rho[i]; //  p[i];
    const float rho_i = rho[i];
    const float m_i = m[i];
    const float Z_i = partition[i];

    // Initialize the output
    #ifndef LOCAL_MEM_SIZE
        #define _GRADP_ grad_p[i].XYZ
        #define _LAPU_ lap_u[i].XYZ
        #define _DIVU_ div_u[i]
    #else
        #define _GRADP_ grad_p_l[it]
        #define _LAPU_ lap_u_l[it]
        #define _DIVU_ div_u_l[it]
        __local vec_xyz grad_p_l[LOCAL_MEM_SIZE];
        __local vec_xyz lap_u_l[LOCAL_MEM_SIZE];
        __local float div_u_l[LOCAL_MEM_SIZE];
        _GRADP_ = VEC_ZERO.XYZ;
        _LAPU_ = VEC_ZERO.XYZ;
        _DIVU_ = 0.f;
    #endif

    BEGIN_LOOP_OVER_NEIGHS(){
        if(i == j){
            j++;
            continue;
        }
        if(imove[j] != 1){
            j++;
            continue;
        }
        const vec_xyz r_ij = r[j].XYZ - r_i;
        const float q = length(r_ij) / H;
        if(q >= SUPPORT)
        {
            j++;
            continue;
        }
        {
            const float rho_j = rho[j];
            const float p_j = p[j];
//            const float p_j = p0 + cs * cs * (rho[j] - refd[iset[j]]); // p0+cs*cs*rho[j]; // p[j];
	    const float fug_j = exp( rho[j] / refd[iset[j]] );
//	    const float fug_j = exp( p_j / (cs * cs) );

            const float udr = dot(u[j].XYZ - u_i, r_ij);
	    const float m_j = m[j];
            const float f_ij = kernelF(q) * CONF * m_j;
	    const float Z_j = partition[j];

// original
//            _GRADP_ += (p_i + p_j) / (rho_i * rho_j) * f_ij * r_ij;

// alt
//            _GRADP_ += ( p_i / (rho_i * rho_i) +  p_j /(rho_j * rho_j) ) * f_ij * r_ij;
//or
//            _GRADP_ += (m_i * p_i / (rho_i * rho_i) + m_j * p_j /(rho_j * rho_j) ) / m_j  * f_ij * r_ij;


//           _GRADP_   += cs*cs*( m_i*m_i / rho_i + m_j*m_j / rho_j ) / (m_i *m_j) * f_ij * r_ij;
//            _GRADP_ += cs * cs * ( rho_i + rho_j) / (rho_i * rho_j) * f_ij * r_ij;
//           _GRADP_   += (m_i / Z_i + m_j / Z_j ) / (m_i *m_j) * f_ij * r_ij;

// exp, with outside p's
           _GRADP_   += cs * cs * ( m_j  / Z_j * fug_i + m_i  / Z_i * fug_j ) / ( m_i * m_j ) * f_ij * r_ij ; //  / CONF;




            #if __LAP_FORMULATION__ == __LAP_MONAGHAN__
                const float r2 = (q * q + 0.01f) * H * H;
                _LAPU_ += f_ij * __CLEARY__ * udr / (r2 * rho_i * rho_j) * r_ij;
            #elif __LAP_FORMULATION__ == __LAP_MORRIS__
                _LAPU_ += f_ij * 2.f / (rho_i * rho_j) * (u[j].XYZ - u_i);
            #else
                #error Unknown Laplacian formulation: __LAP_FORMULATION__
            #endif

            _DIVU_ += udr * f_ij * rho_i / rho_j;
        }
    }END_LOOP_OVER_NEIGHS()

    #ifdef LOCAL_MEM_SIZE
        grad_p[i].XYZ = _GRADP_;
        lap_u[i].XYZ = _LAPU_;
        div_u[i] = _DIVU_;
    #endif
}
