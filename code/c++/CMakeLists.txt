cmake_minimum_required(VERSION 3.1)
project(re2_benchmark)

set(GXX_COMPILE_FLAGS "-lre2")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${GXX_COMPILE_FLAGS} -std=c++11")

set(SOURCE_FILES
    main.cpp
    FileService.cpp
    FileService.h)

#include(ExternalProject)
#ExternalProject_Add(
#   re2
#   GIT_REPOSITORY https://github.com/google/re2.git
#   GIT_TAG master
#   BUILD_COMMAND make
#   INSTALL_COMMAND make install
#)

add_executable(re2_benchmark ${SOURCE_FILES})