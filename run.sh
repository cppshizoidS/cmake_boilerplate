#!/bin/bash
if [ -x "$(command -v apt-get)" ]; then
    sudo apt-get update
    sudo apt-get install -y zsh build-essential neofetch git clang clang-tools mold clang-format gcc cmake ninja-build lld lldb valgrind gtest python3-pip doxygen neovim qt5-default qtbase5-dev qt6-base-dev qt6-base glfw glew libglm-dev glew-utils libglew-dev vulkan-tools vulkan-utils vulkan-loader glslang-dev spirv-tools libsfml-dev sfml
elif [ -x "$(command -v dnf)" ]; then
    sudo dnf install -y dnf5
    sudo dnf5 install -y zsh @development-tools neofetch git clang clang-tools-extra mold gcc cmake ninja-build lld lldb valgrind python3 python3-pip gtest doxygen neovim SFML SFML-devel qt5-qtbase-devel qt5-qtbase qt6-core qt6-qtbase qt6-qtbase-devel qt6-qtmutimedia glfw glm-devel glew vulkan-headers vulkan-loader vulkan-tools vulkan-volk-devel glslang spirv-tools spirv-llvm-translator
elif [ -x "$(command -v pacman)" ]; then
    sudo pacman -Syyu --noconfirm zsh base-devel neofetch neovim python python-pip lua git clang mold compiler-rt gcc cmake doxygen ninja make lld lldb valgrind gtest qt5-base qt5-multimedia qt5-quick3d qt6-tools qt6-quick3d qt6-multimedia glfw glew glm vulkan-extra-layers vulkan-extra-tools vulkan-headers vulkan-tools vulkan-validation-layers spirv-llvm-translator sfml
elif [ -x "$(command -v brew)" ]; then
    brew install zsh xcodebuild neofetch neovim python3 git clang cmake doxygen ninja make lld lldb valgrind qt5 qt6 glfw glew glm vulkan-headers vulkan-loader vulkan-tools vulkan-extenstionlayer vulkan-validationlayer spirv-cross spirv-headers spirv-llvm-translator xcode-build-server googletest sfml
else
    echo "Не удалось определить дистрибутив и установщик пакетов."
    exit 1
fi

pip3 install conan

set -e
set -x

# Save the current directory
BASEDIR=$(pwd)
pushd "$BASEDIR"

# Setup Zsh
chsh -s /bin/zsh ${USER}
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh &&
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions &&
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting &&
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k 

echo '
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
    git
    sudo
    zsh-autosuggestions
    zsh-syntax-highlighting
)

alias zshconfig="nvim ~/.zshrc"
alias src="source ~/.zshrc"

alias vim="nvim"
alias nv="nvim"

source $ZSH/oh-my-zsh.sh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
' > ~/.zshrc

source ~/.zshrc

mkdir ~/.config/nvim

echo ':set number
:set autoindent
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set softtabstop=4
:set mouse=a
:set relativenumber
:set nohlsearch
:set shell=/usr/bin/zsh
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
colorscheme onedark' > ~/.config/nvim/init.vim

popd

rm -rf build

conan profile detect --force
conan install . --output-folder=build --build=missing
cd build
cmake .. -G Ninja -DCMAKE_BUILD_TYPE=Release 
cmake --build .
./test
