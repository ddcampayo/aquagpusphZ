#!/bin/bash

if [[ $1 == "--run" ]]; then
    rm -f Fluid.dat
    rm -f BC.dat
    rm -f AQUAgpusph.save.*.xml
    rm -f log.*.html
    rm -f *.vtu
    rm -f *.pvd
    rm -f Timing.dat
    rm -f Performance.dat
    /usr/local/share/aquagpusph/examples/2D/spheric_testcase3_liddriven/cMake/../Create.py
    /usr/local/bin/AQUAgpusph2D -i Main.xml
elif [[ $1 == "--plot" ]]; then
    python /usr/local/share/aquagpusph/examples/2D/spheric_testcase3_liddriven/cMake/../plot_$2.py
else
    echo ""
    echo "Usage: run.sh [--run/--plot]"
    echo ""
    echo "run.sh --plot t"
    echo "    Plot the performance"
    echo ""
fi
