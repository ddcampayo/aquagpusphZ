#!/bin/bash

if [[ $1 == "--run" ]]; then
    rm -f Solid.dat
    rm -f BuiltInBC.dat
    rm -f FreeBC.dat
    rm -f AQUAgpusph.save.*.xml
    rm -f log.*.html
    rm -f *.vtu
    rm -f *.pvd
    rm -f Timing.dat
    rm -f Performance.dat
    /home/daniel/aquagpusph/build/examples/2D/built_in_beam/Create.py
    /home/daniel/aquagpusph/build/bin/AQUAgpusph2D -i Main.xml
elif [[ $1 == "--plot" ]]; then
    python /home/daniel/aquagpusph/build/examples/2D/built_in_beam/plot_$2.py
else
    echo ""
    echo "Usage: run.sh [--run/--plot t]"
    echo ""
    echo "run.sh --run"
    echo "    Runs the simulation. You can stop simulation pressing the 'c' key"
    echo "run.sh --plot t"
    echo "    Plot the performance"
    echo ""
fi
