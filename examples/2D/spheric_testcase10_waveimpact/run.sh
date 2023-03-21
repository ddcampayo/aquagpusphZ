#!/bin/bash

if [[ $1 == "--run" ]]; then
    rm -f Sensors.dat
    rm -f Fluid.dat
    rm -f AQUAgpusph.save.*.xml
    rm -f log.*.html
    rm -f output.*.vtu
    rm -f output.pvd
    rm -f sensors.*.vtu
    rm -f sensors.pvd
    rm -f sensors.out
    rm -f Timing.dat
    rm -f Performance.dat
    /home/daniel/aquagpusph.gcc/examples/2D/spheric_testcase10_waveimpact/Create.py
    /home/daniel/aquagpusph.gcc/bin/AQUAgpusph2D -i Main.xml
elif [[ $1 == "--plot" ]]; then
    python /home/daniel/aquagpusph.gcc/examples/2D/spheric_testcase10_waveimpact/plot_$2.py
else
    echo ""
    echo "Usage: run.sh [--run/--plot]"
    echo ""
    echo "run.sh --plot p"
    echo "    Plot the pressure in the sensor"
    echo "run.sh --plot t"
    echo "    Plot the performance"
    echo ""
fi
