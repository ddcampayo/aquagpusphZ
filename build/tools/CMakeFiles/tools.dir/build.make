# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.17

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Disable VCS-based implicit rules.
% : %,v


# Disable VCS-based implicit rules.
% : RCS/%


# Disable VCS-based implicit rules.
% : RCS/%,v


# Disable VCS-based implicit rules.
% : SCCS/s.%


# Disable VCS-based implicit rules.
% : s.%


.SUFFIXES: .hpux_make_needs_suffix_list


# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/daniel/aquagpusph

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/daniel/aquagpusph/build

# Utility rule file for tools.

# Include the progress variables for this target.
include tools/CMakeFiles/tools.dir/progress.make

tools/CMakeFiles/tools:
	cd /home/daniel/aquagpusph/build/tools && /usr/bin/python3.8 setup.py build

tools: tools/CMakeFiles/tools
tools: tools/CMakeFiles/tools.dir/build.make

.PHONY : tools

# Rule to build all files generated by this target.
tools/CMakeFiles/tools.dir/build: tools

.PHONY : tools/CMakeFiles/tools.dir/build

tools/CMakeFiles/tools.dir/clean:
	cd /home/daniel/aquagpusph/build/tools && $(CMAKE_COMMAND) -P CMakeFiles/tools.dir/cmake_clean.cmake
.PHONY : tools/CMakeFiles/tools.dir/clean

tools/CMakeFiles/tools.dir/depend:
	cd /home/daniel/aquagpusph/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/daniel/aquagpusph /home/daniel/aquagpusph/tools /home/daniel/aquagpusph/build /home/daniel/aquagpusph/build/tools /home/daniel/aquagpusph/build/tools/CMakeFiles/tools.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : tools/CMakeFiles/tools.dir/depend
