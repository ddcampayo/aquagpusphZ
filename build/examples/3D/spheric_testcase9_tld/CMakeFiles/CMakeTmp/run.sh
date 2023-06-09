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
    /usr/local/share/aquagpusph/examples/3D/spheric_testcase9_tld/cMake/../Create.py
    /usr/local/bin/AQUAgpusph -i Main.xml
elif [[ $1 == "--plot" ]]; then
    python /usr/local/share/aquagpusph/examples/3D/spheric_testcase9_tld/cMake/../plot_$2.py
else
    echo ""
    echo "Usage: run.sh [--run/--plot]"
    echo ""
    echo "run.sh --plot m"
    echo "    Plot the resulting motion"
    echo "run.sh --plot t"
    echo "    Plot the performance"
    echo ""
fi
