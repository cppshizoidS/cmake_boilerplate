FROM fedora:latest

RUN dnf install -y dnf5 && \
    dnf5 install -y zsh @development-tools neofetch git clang clang-tools-extra mold gcc cmake ninja-build lld lldb valgrind python3 python3-pip gtest doxygen neovim SFML SFML-devel qt5-qtbase-devel qt5-qtbase qt6-qtbase qt6-qtbase-devel qt6-qtmultimedia glfw glm-devel glew vulkan-headers vulkan-loader vulkan-tools vulkan-volk-devel glslang spirv-tools spirv-llvm-translator && \
    pip3 install conan && \
    dnf clean all

COPY docker_devenv.sh /docker_devenv.sh

RUN chmod +x /docker_devenv.sh && /docker_devenv.sh

COPY . /project

WORKDIR /project

RUN conan profile detect --force && \
    conan install . --output-folder=build --build=missing

RUN mkdir -p build && cd build && \
    cmake .. -G Ninja -DCMAKE_BUILD_TYPE=Release && \
    cmake --build .

CMD ["./build/test"]

# CMD ["./build/test"]
