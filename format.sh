#!/bin/bash

# Define source files
SOURCE_FILES=$(find src include -name '*.cpp' -o -name '*.hpp' -o -name '*.h' -o -name '*.cppm' -o -name '*.ixx')

# Run clang-format
clang-format -i $SOURCE_FILES
