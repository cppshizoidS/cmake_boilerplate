#!/bin/bash

# Create and build Debug
mkdir -p build/debug
cd build/debug
cmake -DCMAKE_BUILD_TYPE=Debug ../..
cmake --build .
cd ../..

# Create and build Release
mkdir -p build/release
cd build/release
cmake -DCMAKE_BUILD_TYPE=Release ../..
cmake --build .
cd ../..

# Create and build RelWithDebInfo
mkdir -p build/relwithdebinfo
cd build/relwithdebinfo
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo ../..
cmake --build .
cd ../..

# Create and build MinSizeRel
mkdir -p build/minsizerel
cd build/minsizerel
cmake -DCMAKE_BUILD_TYPE=MinSizeRel ../..
cmake --build .
cd ../..
