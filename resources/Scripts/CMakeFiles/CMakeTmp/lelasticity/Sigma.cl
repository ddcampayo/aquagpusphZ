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
 * @brief Stress tensor computation
 */

#include "resources/Scripts/types/types.h"

/** @brief Stress tensor computation.
 *
 * \f[ \sigma = p \mathcal{I} + S \f]
 *
 * @see https://en.wikipedia.org/wiki/Linear_elasticity
 * @see https://en.wikipedia.org/wiki/Hooke's_law
 *
 * @param p Pressure \f$ p \f$.
 * @param S Deviatory stress \f$ S \f$.
 * @param sigma Stress tensor \f$ \sigma \f$.
 * @param N Number of particles.
 */
__kernel void entry(const __global float* p,
                    const __global matrix* S,
                    __global matrix* sigma,
                    unsigned int N)
{
    unsigned int i = get_global_id(0);
    if(i >= N)
        return;

    sigma[i] = p[i] * MAT_EYE - S[i]; 
}

/*
 * @}
 */