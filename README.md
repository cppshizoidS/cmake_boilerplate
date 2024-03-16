# My boilerplate for cmake projects with ci/cd

Structure:

```sh
.
├── .github/workflows
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
├── .clang-format
├── .gitignore
├── CMakeLists.txt
├── compile_commands.json -> build/compile_commands.json(for clangd in nvim/vsc)
├── conanfile.txt
├── LICENSE
└── README.md
```

I use [conan](https://conan.io/) for pm, [cmake](https://cmake.org/) for generator files for [ninja-build](https://ninja-build.org/), [clang-format](https://clang.llvm.org/docs/ClangFormat.html) for format and [doxygen](https://www.doxygen.nl/manual/index.html) for generate docs. It can be used for graphics project.

---
This template contains a script to install everything you need
