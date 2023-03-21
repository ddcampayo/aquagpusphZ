#!/bin/bash

set -e

# Clean up before running, so previous failures are not contaminating the
# results
rm -f AQUAgpusph.save.* log.* set0.*.dat set1.*.dat

# Run the "simulation"
/home/daniel/aquagpusph/build/bin/AQUAgpusph2D -i main.xml

# Check the result
python /home/daniel/aquagpusph/build/tests/2D/Sort/check.py
