#!/bin/bash

set -e

# Clean up before running, so previous failures are not contaminating the
# results
rm -f AQUAgpusph.save.* log.* out_*.dat

# Run the "simulation"
mpirun --hostfile hostfile /home/daniel/aquagpusph/build/bin/AQUAgpusph2D -i main.xml

# Check the result
python /home/daniel/aquagpusph/build/tests/2D/MPI/check.py
