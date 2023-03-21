#!/bin/bash

if [[ $1 == "--run" ]]; then
    rm -f Fluid.dat
    rm -f AQUAgpusph.save.*.xml
    rm -f log.*.html
    rm -f output.*.vtu
    rm -f output.pvd
    rm -f Timing.dat
    rm -f Forces.dat
    rm -f Performance.dat
    /home/daniel/aquagpusph/build/examples/2D/spheric_testcase9_tld/Create.py
    /home/daniel/aquagpusph/build/bin/AQUAgpusph2D -i Main.xml
elif [[ $1 == "--plot" ]]; then
    python /home/daniel/aquagpusph/build/examples/2D/spheric_testcase9_tld/plot_$2.py
else
    echo ""
    echo "Usage: run.sh [--run/--plot m/--plot t]"
    echo ""
    echo "run.sh --run"
    echo "    Runs the simulation. You can stop simulation pressing the 'c' key"
    echo "run.sh --plot m"
    echo "    Plot the resulting motion"
    echo "run.sh --plot t"
    echo "    Plot the performance"
    echo ""
fi
