#!/bin/bash
if [ -x "$(command -v apt-get)" ]; then
    sudo apt-get update
    sudo apt-get install -y build-essential neofetch git clang clang-tools clang-format gcc cmake ninja-build lld lldb valgrind gtest python3-pip doxygen neovim qt5-default qtbase5-dev qt6-base-dev qt6-base glfw glew libglm-dev glew-utils libglew-dev vulkan-tools vulkan-utils vulkan-loader glslang-dev spirv-tools
elif [ -x "$(command -v dnf)" ]; then
    sudo dnf install -y @development-tools neofetch git clang clang-tools-extra gcc cmake ninja-build lld lldb valgrind python3-pip gtest doxygen neovim qt5-qtbase-devel qt5-qtbase qt6-core qt6-qtbase qt6-qtbase-devel qt6-qtmutimedia  glfw glm-devel glew vulkan-headers vulkan-loader vulkan-tools vulkan-volk-devel glslang spirv-tools spirv-llvm-translator
elif [ -x "$(command -v pacman)" ]; then
    sudo pacman -Syyu -noconfirm base-devel neofetch neovim lua git clang compiler-rt gcc cmake ninja make lld lldb valgrind gtest qt5-base qt5-multimedia qt5-quick3d qt6-tools qt6-quick3d qt6-multimedia glfw glew glm vulkan-extra-layers vulkan-extra-tools vulkan-headers vulkan-tools vulkan-validation-layers spirv-llvm-translator
elif [ -x "$(command -v brew)" ]; then
    brew install xcodebuild neofetch neovim python3  git clang cmake ninja make lld lldb valgrind qt5  qt6 glfw glew glm vulkan-headers vulkan-loader vulkan-tools vulkan-extenstionlayer vulkan-validationlayer spirv-cross spirv-headers spirv-llvm-translator xcode-build-server googletest
else
    echo "Не удалось определить дистрибутив и установщик пакетов."
    exit 1
fi
pip3 install conan

set -e
set -x

BASEDIR=$(dirname "$0")
pushd "$BASEDIR"

rm -rf build

conan profile detect --force
conan install . --output-folder=build --build=missing
cd build
cmake .. -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake
cmake --build .
./test
