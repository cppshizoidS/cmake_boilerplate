# My boilerplate for cmake projects with ci/cd

Structure:

```sh
├── .github/workflows
│   └── build_cmake.yml
├── build(contains generation from cmake(ninja.build) and also contains compile_commands.json
├── docs
│   └── CMakeLists.txt
│   └── Doxyfile.in  
├── include
│   └── *.hpp
├── lib
|   ├── include
│       └── *.hpp
|   ├── src
|       └── *.cpp
|   └── CMakeLists.txt
│── shaders(for graphics project)
│   └── *.frag/.vert
├── src
│   └── *.cpp
├── test
│   └── CMakeLists.txt
│   └── test_*.cpp
├── .clang-format
├── .gitignore
├── CMakeLists.txt
├── CMakePresets.json (for Visual studio)
├── compile_commands.json -> build/compile_commands.json(for clangd in nvim/vsc)
├── Dockerfile
├── LICENSE
└── README.md
```

I use  [vcpkg](https://vcpkg.io/en/index.html) for pm, [cmake](https://cmake.org/) for generator files for [ninja-build](https://ninja-build.org/), [clang-format](https://clang.llvm.org/docs/ClangFormat.html) for format and [doxygen](https://www.doxygen.nl/manual/index.html) for generate docs.
GTest for Unit Test and Ctest for running tests. It can be used for graphics project.

---
This template contains everything you need:
* Ready CMakeLists.txt
* script for install all needed packages(for debain based, fedora, arch based & macos)
* github.ci(ci drops in this repo because it used many packages and some conflicts, pick packages what you need)
* .gitignore
* clang-foramt
* setuped doxygen
* caching on ci
* basic setup for nvim zsh OMZ
* IWYU
* setuped CTest and GTest
* shader build script
* different configurations: debug, release...
* debug configs enable flags for most checks for compilers (clang/gcc and msvc)
* docker setup

### Build Debug

```sh
mkdir -p build/debug
cd build/debug
cmake -DCMAKE_BUILD_TYPE=Debug ../..
cmake --build .
```

### Build Release:
```sh
mkdir -p build/release
cd build/release
cmake -DCMAKE_BUILD_TYPE=Release ../..
cmake --build .
```

### Build RelWithDebugInfo
```sh
mkdir -p build/relwithdebinfo
cd build/relwithdebinfo
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo ../..
cmake --build .
```

### Build MinSizeRel
```sh
mkdir -p build/minsizerel
cd build/minsizerel
cmake -DCMAKE_BUILD_TYPE=MinSizeRel ../..
cmake --build .
```
