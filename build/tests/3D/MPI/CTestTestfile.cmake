# CMake generated Testfile for 
# Source directory: /home/daniel/aquagpusph/tests/3D/MPI
# Build directory: /home/daniel/aquagpusph/build/tests/3D/MPI
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(MPI_test "/usr/bin/bash" "/home/daniel/aquagpusph/build/tests/3D/MPI/run.sh")
set_tests_properties(MPI_test PROPERTIES  _BACKTRACE_TRIPLES "/home/daniel/aquagpusph/tests/3D/MPI/CMakeLists.txt;22;ADD_TEST;/home/daniel/aquagpusph/tests/3D/MPI/CMakeLists.txt;0;")
