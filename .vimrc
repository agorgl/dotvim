" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Set the vim user folder in windows to the %USERPROFILE%/.vim/
if has('win32') || has('win64')
    set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif

" ================ General Config ====================
set nowrap                                  " Don't wrap lines
set autoread                                " Reload files changed outside vim
set backspace=indent,eol,start              " Allow backspace in insert mode
set number                                  " Show line numbers
set showcmd                                 " Show incomplete cmds down the bottom
set showmode                                " Show current mode down the bottom

" No sounds
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" Enable syntax highlighting
syntax on

" Enable useful search options
set hlsearch                                " Highlight search terms
set incsearch                               " Show search matches as you type

" Enable useful autocomplete for commands
set wildmenu
set wildmode=list:longest,list:full

" Remove preview window from autocompletion
set completeopt-=preview

" Turn Off Swap Files
set noswapfile
set nobackup
set nowb

" Indentation
set autoindent
set smartindent
set smarttab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab

" Natural splits
set splitbelow
set splitright

" Unix line endings
set fileformats=unix,dos

" ================ User Scripts ======================
set runtimepath+=$HOME/.vim/conf/scripts
for f in split(glob('~/.vim/conf/scripts/*.vim'), '\n')
    exe 'source' f
endfor

" ================ Appearance ========================
set encoding=utf-8
" Set the font
if has('win32') || has('win64')
    set guifont=Consolas:h10
elseif has('gui_gtk2')
    set guifont=Source\ Code\ Pro\ for\ Powerline\ 10
endif
let g:rehash256 = 1                         " Molokai fix flag for 256 color terminals
colorscheme molokai                         " Set the color scheme

" Enable transparent background on terminals
"if !has("gui_running")
"    let g:nobg256 = 1
"    call EnableTransparentBg()
"endif

" ================ Gui options =======================
if has("gui_running")
    "Strip unwanted window stuff
    set guioptions-=m                       " Remove menu bar
    set guioptions-=T                       " Remove toolbar
    set guioptions-=r                       " Remove right-hand scroll bar
    set guioptions-=L                       " Remove left-hand scroll bar
endif

if has('win32') || has('win64')
    au GUIEnter * simalt ~x                 " Maximize gVim window
endif

" ================ Startup ===========================
" Start plugin handling
call plug#begin('~/.vim/bundle')

" General
Plug 'airblade/vim-gitgutter'
Plug 'embear/vim-localvimrc'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/vim-easy-align'
Plug 'kien/ctrlp.vim'
Plug 'kburdett/vim-nuuid'
Plug 'rust-lang/rust.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'SirVer/ultisnips'
Plug 'skywind3000/asyncrun.vim'
Plug 'tpope/vim-fugitive'
Plug 'Chiel92/vim-autoformat'
Plug 'Shougo/neocomplete.vim'
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'tikhomirov/vim-glsl'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'xolox/vim-misc'
Plug 'vim-scripts/Conque-GDB', {
  \     'on': [
  \         'ConqueGdb',
  \         'ConqueGdbSplit',
  \         'ConqueGdbVSplit',
  \         'ConqueGdbTab',
  \         'ConqueGdbExe',
  \         'ConqueGdbDelete',
  \         'ConqueGdbCommand',
  \         'ConqueTerm',
  \         'ConqueTermSplit',
  \         'ConqueTermVSplit',
  \         'ConqueTermTab',
  \     ]
  \ }
Plug 'Shougo/vimshell.vim', {
  \ 'on' : [
  \         'VimShell',
  \         'VimShellCreate',
  \         'VimShellPop',
  \         'VimShellTab',
  \         'VimShellCurrentDir',
  \         'VimShellBufferDir',
  \         'VimShellExecute',
  \         'VimShellInteractive',
  \         'VimShellSendString',
  \         'VimShellSendBuffer',
  \         'VimShellClose'
  \     ]
  \ }
Plug 'Valloric/YouCompleteMe', {
  \ 'for': ['c', 'cpp', 'python', 'cs', 'haskell', 'lua', 'java', 'rust'],
  \ 'do': './install.py --system-libclang --clang-completer --racer-completer'
  \ }
" OpenCL
Plug 'petRUShka/vim-opencl', { 'for': 'opencl' }
" Haskell
Plug 'eagletmt/ghcmod-vim', { 'for': 'haskell' }
Plug 'eagletmt/neco-ghc', { 'for': 'haskell' }
" Java
Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java' }
" Lua
Plug 'xolox/vim-lua-ftplugin', { 'for': 'lua' }
" LaTeX
Plug 'lervag/vimtex', { 'for': 'tex' }

" End plugin handling
call plug#end()

" Filetype detection enable
filetype plugin indent on

" ================ Plugins Conf ======================
set runtimepath+=$HOME/.vim/conf/plugins
for f in split(glob('~/.vim/conf/plugins/*.vim'), '\n')
    exe 'source' f
endfor
