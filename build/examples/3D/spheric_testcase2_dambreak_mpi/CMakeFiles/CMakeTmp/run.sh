#!/bin/bash

if [[ $1 == "--run" ]]; then
    rm -f clinfo_*
    rm -f Sensors.dat
    rm -f Fluid.dat
    rm -f AQUAgpusph.save.*.xml
    rm -f log.*.html
    rm -f output*.vtu
    rm -f output*.pvd
    rm -f sensors*.vtu
    rm -f sensors*.pvd
    rm -f sensors*.out
    rm -f sensors_h*.out
    rm -f Timing.dat
    rm -f Performance.dat
    # Extract useful information from clinfo
    clinfo | grep "Number of devices" > clinfo_platforms
    clinfo | grep "Device Type" > clinfo_devices
    /usr/local/share/aquagpusph/examples/3D/spheric_testcase2_dambreak_mpi/cMake/../Create.py
    mpirun --hostfile hostfile /usr/local/bin/AQUAgpusph -i Main.xml
elif [[ $1 == "--plot" ]]; then
    python /usr/local/share/aquagpusph/examples/3D/spheric_testcase2_dambreak_mpi/cMake/../plot_$2.py
else
    echo ""
    echo "Usage: run.sh [--run/--plot]"
    echo ""
    echo "run.sh --run"
    echo "    Runs the simulation. You can stop simulation pressing the 'c' key"
    echo "run.sh --plot p"
    echo "    Plot the pressure"
    echo "run.sh --plot h"
    echo "    Plot the wave height"
    echo "run.sh --plot t"
    echo "    Plot the performance"
    echo ""
fi
