# Install Chocolatey if not already installed
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# Install packages
choco install -y git cmake ninja llvm clang gcc neovim doxygen sfml qt5-sdk qt6-sdk glfw glew glm vulkan-sdk python3 python3-pip

# Setup vcpkg
cd $HOME
if (-not (Test-Path -Path "$HOME\vcpkg")) {
    git clone https://github.com/microsoft/vcpkg.git
}
cd vcpkg
.\bootstrap-vcpkg.bat
.\vcpkg integrate install
cd ..

# Save the current directory
$BASEDIR = Get-Location

# Setup neovim
New-Item -ItemType Directory -Force -Path $HOME\AppData\Local\nvim\autoload
Invoke-WebRequest -Uri https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -OutFile $HOME\AppData\Local\nvim\autoload\plug.vim

@"
:set number
:set autoindent
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set softtabstop=4
:set mouse=a
:set relativenumber
:set nohlsearch
:set noswapfile
:set fileformat=unix
:set encoding=utf-8
:set clipboard=unnamedplus

call plug#begin()

Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdtree'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'https://github.com/ryanoasis/vim-devicons'

Plug 'tpope/vim-commentary'
Plug 'tc50cal/vim-terminal'
Plug 'jiangmiao/auto-pairs'
Plug 'joshdick/onedark.vim'
Plug 'neovim/nvim-lspconfig'

Plug 'kyazdani42/nvim-web-devicons' " icons

Plug 'octol/vim-cpp-enhanced-highlight'
let g:cpp_class_scope_highlight = 1
let g:cpp_class_decl_highlight  = 1

let g:airline_theme='onedark'

call plug#end()

nnoremap <C-a> ggVG<CR>
xnoremap p pgddvy

nnoremap <C-t> :NvimTreeToggle<CR>
inoremap <silent><expr> <TAB> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<TAB>"

:set termguicolors
colorscheme onedark
"@ | Out-File -FilePath $HOME\AppData\Local\nvim\init.vim -Encoding utf8

# Build and run the project
if (Test-Path -Path "$BASEDIR\build") {
    Remove-Item -Recurse -Force build
}

mkdir build
cd build

cmake .. -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=$BASEDIR\vcpkg\scripts\buildsystems\vcpkg.cmake
cmake --build .

if (Test-Path -Path ".\test.exe") {
    .\test.exe
} else {
    Write-Host "Error: could not find 'test.exe'. Ensure the build was successful."
}
