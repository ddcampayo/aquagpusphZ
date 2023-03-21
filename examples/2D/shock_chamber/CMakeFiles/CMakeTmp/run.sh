#!/bin/bash

if [[ $1 == "--run" ]]; then
    rm -f Fluid.dat
    rm -f AQUAgpusph.save.*.xml
    rm -f log.*.html
    rm -f output.*.vtu
    rm -f output.pvd
    rm -f Timing.dat
    rm -f Performance.dat
    /usr/share/aquagpusph/examples/2D/shock_chamber/cMake/../Create.py
    /usr/bin/AQUAgpusph2D -i Main.xml
elif [[ $1 == "--plot" ]]; then
    python /usr/share/aquagpusph/examples/2D/shock_chamber/cMake/../plot_$2.py
else
    echo ""
    echo "Usage: run.sh [--run/--plot p/--plot h]"
    echo ""
    echo "run.sh --run"
    echo "    Runs the simulation. You can stop simulation pressing the 'c' key"
    echo "run.sh --plot t"
    echo "    Plot the performance"
    echo ""
fi
