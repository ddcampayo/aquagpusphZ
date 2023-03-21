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
 * @brief Improved Euler time integration scheme corrector stage
 */

#include "resources/Scripts/types/types.h"

/** @brief Improved Euler time integration scheme corrector stage
 *
 * Time integration is based in the following quasi-second order
 * Predictor-Corrector integration scheme:
 * 
 *   \f$ \S_{n+1} = \S_{n} + \Delta t
 *      \left. \frac{\mathrm{d}S}{\mathrm{d}t} \right\vert_{n+1/2}
 *   + \frac{\Delta t}{2} \left(
 *      \left. \frac{\mathrm{d}S}{\mathrm{d}t} \right\vert_{n + 1/2} -
 *      \left. \frac{\mathrm{d}S}{\mathrm{d}t} \right\vert_{n - 1/2}
 *   \right) \f$
 *
 * @param imove Moving flags.
 *   - imove > 0 for regular fluid particles.
 *   - imove = 0 for sensors.
 *   - imove < 0 for boundary elements/particles.
 * @param iset Set of particles index.
 * @param S Deviatory stress \f$ S_{n+1} \f$.
 * @param dSdt Deviatory stress rate of change
 * \f$ \left. \frac{d S}{d t} \right\vert_{n+1} \f$.
 * @param S_in  Deviatory stress \f$ S_{n+1/2} \f$.
 * @param dSdt_in  Deviatory stress rate of change
 * \f$ \left. \frac{d S}{d t} \right\vert_{n+1/2} \f$.
 * @param N Number of particles.
 * @param dt Time step \f$ \Delta t \f$.
 * @see lela/Predictor.cl
 */
__kernel void entry(__global int* imove,
                    __global matrix* S,
                    __global matrix* dSdt,
                    __global matrix* S_in,
                    __global matrix* dSdt_in,
                    unsigned int N,
                    float dt)
{
    unsigned int i = get_global_id(0);
    if(i >= N)
        return;

    float DT = 0.5f * dt;
    if(imove[i] <= 0)
        DT = 0.f;

    S[i] += DT * (dSdt[i] - dSdt_in[i]);
    S_in[i] = S[i];
}

/*
 * @}
 */