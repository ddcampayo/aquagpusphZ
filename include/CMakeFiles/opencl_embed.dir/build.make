# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.25

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

#Suppress display of executed commands.
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
CMAKE_BINARY_DIR = /home/daniel/aquagpusph.gcc

# Utility rule file for opencl_embed.

# Include any custom commands dependencies for this target.
include include/CMakeFiles/opencl_embed.dir/compiler_depend.make

# Include the progress variables for this target.
include include/CMakeFiles/opencl_embed.dir/progress.make

opencl_embed: include/CMakeFiles/opencl_embed.dir/build.make
.PHONY : opencl_embed

# Rule to build all files generated by this target.
include/CMakeFiles/opencl_embed.dir/build: opencl_embed
.PHONY : include/CMakeFiles/opencl_embed.dir/build

include/CMakeFiles/opencl_embed.dir/clean:
	cd /home/daniel/aquagpusph.gcc/include && $(CMAKE_COMMAND) -P CMakeFiles/opencl_embed.dir/cmake_clean.cmake
.PHONY : include/CMakeFiles/opencl_embed.dir/clean

include/CMakeFiles/opencl_embed.dir/depend:
	cd /home/daniel/aquagpusph.gcc && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/daniel/aquagpusph /home/daniel/aquagpusph/include /home/daniel/aquagpusph.gcc /home/daniel/aquagpusph.gcc/include /home/daniel/aquagpusph.gcc/include/CMakeFiles/opencl_embed.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : include/CMakeFiles/opencl_embed.dir/depend

