#!/bin/bash

if [[ $1 == "--run" ]]; then
    rm -f Fluid.dat
    rm -f Cylinder.dat
    rm -f AQUAgpusph.save.*.xml
    rm -f log.*.html
    rm -f output.*.vtu
    rm -f output.pvd
    rm -f cylinder.*.vtu
    rm -f cylinder.pvd
    rm -f Timing.dat
    rm -f Performance.dat
    /home/daniel/aquagpusph/build/examples/2D/cylinder_inside_channel/Create.py
    /home/daniel/aquagpusph/build/bin/AQUAgpusph2D -i Main.xml
elif [[ $1 == "--plot" ]]; then
    python /home/daniel/aquagpusph/build/examples/2D/cylinder_inside_channel/plot_$2.py
else
    echo ""
    echo "Usage: run.sh [--run/--plot f/--plot t]"
    echo ""
    echo "run.sh --run"
    echo "    Runs the simulation. You can stop simulation pressing the 'c' key"
    echo "run.sh --plot f"
    echo "    Plot the Lift and Drag coefficients"
    echo "run.sh --plot t"
    echo "    Plot the performance"
    echo ""
fi
