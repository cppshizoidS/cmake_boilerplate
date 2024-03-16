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

I use [conan](https://conan.io/) for pm, [cmake](https://cmake.org/), [clang-format](https://clang.llvm.org/docs/ClangFormat.html) and [doxygen](https://www.doxygen.nl/manual/index.html). It can be used for graphics project.
