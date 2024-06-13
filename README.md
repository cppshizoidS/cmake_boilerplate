# My boilerplate for cmake projects with ci/cd

Structure:

```sh
├── .github/workflows
│   └── build_cmake.yml
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
├── compile_commands.json -> build/compile_commands.json(for clangd in nvim/vsc)
├── conanfile.txt
├── LICENSE
└── README.md
```

I use [conan](https://conan.io/) for pm, [cmake](https://cmake.org/) for generator files for [ninja-build](https://ninja-build.org/), [clang-format](https://clang.llvm.org/docs/ClangFormat.html) for format and [doxygen](https://www.doxygen.nl/manual/index.html) for generate docs.
GTest for Unit Test and Ctest for running tests. It can be used for graphics project.

---
This template contains everything you need:
* Ready CMakeLists.txt
* conanfile
* script for install all needed packages
* github.ci
* .gitignore
* clang-foramt
* setuped doxygen
* caching on ci
* IWYU
* setuped CTest and GTest
* shader build script
* different configurations: debug, release...

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