# My boilerplate for cmake qt projects with ci/cd

Structure:

```sh
.
├── .github/workflows
├── docs
│   └── CMakeLists.txt
│   └── Doxyfile.in
├── img
│   └── *.jpg/png
├── include
│   └── *.hpp
├── lib
|   ├── include
│       └── *.hpp
|   ├── src
|       └── *.cpp
|   └── CMakeLists.txt
│── res
│   └── *.qrc
├── src
│   └── *.cpp
├── .clang-format
├── .gitignore
├── CMakeLists.txt
├── compile_commands.json -> build/compile_commands.json(for clangd in nvim/vsc)
├── conanfile.txt
├── LICENSE
└── README.md
```

I use [conan](https://conan.io/) for pm, [cmake](https://cmake.org/) for generator files for [ninja-build](https://ninja-build.org/), [clang-format](https://clang.llvm.org/docs/ClangFormat.html) for format and [doxygen](https://www.doxygen.nl/manual/index.html) for generate docs. 

---
This template contains a script to install everything you need
