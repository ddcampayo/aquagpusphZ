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

/** @addtogroup lela
 * @{
 */

/** @file
 * @brief Solid particles deformation gradient computation.
 */

#if defined(LOCAL_MEM_SIZE) && defined(NO_LOCAL_MEM)
    #error NO_LOCAL_MEM has been set.
#endif

#include "resources/Scripts/types/types.h"
#include "resources/Scripts/KernelFunctions/Kernel.h"

/** @brief Solid particles deformation gradient computation.
 *
 * Compute the gradient of the deformation vector:
 * \f[ \nabla \mathbf{r}^{*} = \mathbf{r}^{*} \otimes \nabla \f]
 *
 * @see https://en.wikipedia.org/wiki/Matrix_calculus
 * @see https://en.wikipedia.org/wiki/Outer_product
 * 
 * @param imove Moving flags.
 *   - imove = 2 for regular solid particles.
 *   - imove = 0 for sensors (ignored by this preset).
 *   - imove < 0 for boundary elements/particles.
 * @param r Position \f$ \mathbf{r} \f$.
 * @param u Velocity \f$ \mathbf{u} \f$.
 * @param rho Density \f$ \rho \f$.
 * @param m Mass \f$ m \f$.
 * @param grad_u Gradient of the velocity \f$ \nabla \mathbf{u} \f$.
 * @param icell Cell where each particle is located.
 * @param ihoc Head of chain for each cell (first particle found).
 * @param N Number of particles.
 * @param n_cells Number of cells in each direction
 */
__kernel void entry(const __global int* imove,
                    const __global vec* r,
                    const __global vec* u,
                    const __global float* rho,
                    const __global float* m,
                    __global matrix* grad_u,
                    // Link-list data
                    const __global uint *icell,
                    const __global uint *ihoc,
                    // Simulation data
                    uint N,
                    uivec4 n_cells)
{
    const uint i = get_global_id(0);
    const uint it = get_local_id(0);
    if(i >= N)
        return;
    if(imove[i] != 2){
        return;
    }

    const vec_xyz r_i = r[i].XYZ;
    const vec_xyz u_i = u[i].XYZ;

    // Initialize the output
    #ifndef LOCAL_MEM_SIZE
        #define _GRADU_ grad_u[i]
    #else
        #define _GRADU_ grad_u_l[it]
        __local matrix grad_u_l[LOCAL_MEM_SIZE];
        _GRADU_ = MAT_ZERO;
    #endif

    BEGIN_LOOP_OVER_NEIGHS(){
        if((i == j) || (imove[j] != 2)){
            j++;
            continue;
        }
        const vec_xyz r_ij = r[j] - r_i.XYZ;
        const float q = length(r_ij) / H;
        if(q >= SUPPORT)
        {
            j++;
            continue;
        }
        {
            const float f_ij = kernelF(q) * CONF * m[j] / rho[j];
            _GRADU_ += outer(u[j].XYZ - u_i, f_ij * r_ij);
        }
    }END_LOOP_OVER_NEIGHS()

    #ifdef LOCAL_MEM_SIZE
        grad_u[i] = _GRADU_;
    #endif
}

/*
 * @}
 */