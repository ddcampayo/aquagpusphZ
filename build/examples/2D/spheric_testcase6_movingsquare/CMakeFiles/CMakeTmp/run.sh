#!/bin/bash

if [[ $1 == "--run" ]]; then
    rm -f Fluid.dat
    rm -f Box.dat
    rm -f Square.dat
    rm -f AQUAgpusph.save.*.xml
    rm -f log.*.html
    rm -f *.vtu
    rm -f *.pvd
    rm -f Timing.dat
    rm -f Performance.dat
    rm -f PressureForces.dat
    rm -f ViscousForces.dat
    /usr/local/share/aquagpusph/examples/2D/spheric_testcase6_movingsquare/cMake/../Create.py
    /usr/local/bin/AQUAgpusph2D -i Main.xml
elif [[ $1 == "--plot" ]]; then
    python /usr/local/share/aquagpusph/examples/2D/spheric_testcase6_movingsquare/cMake/../plot_$2.py
else
    echo ""
    echo "Usage: run.sh [--run/--plot f/--plot t]"
    echo ""
    echo "run.sh --run"
    echo "    Runs the simulation. You can stop simulation pressing the 'c' key"
    echo "run.sh --plot f"
    echo "    Plot the Drag coefficient"
    echo "run.sh --plot f"
    echo "    Plot the Power terms"
    echo "run.sh --plot t"
    echo "    Plot the performance"
    echo ""
fi
