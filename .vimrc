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
" Load plugin manager
set runtimepath+=~/.vim/bundle/neobundle.vim/
call neobundle#begin(expand('~/.vim/bundle/'))

" Increase the install timeout
let g:neobundle#install_process_timeout = 1500

" Load plugins

" General
NeoBundle 'jiangmiao/auto-pairs'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'rust-lang/rust.vim'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'SirVer/ultisnips'
NeoBundle 'Chiel92/vim-autoformat'
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'Shougo/vimproc.vim', {
  \ 'build' : {
  \            'windows': 'tools\\update-dll-mingw',
  \            'cygwin': 'make -f make_cygwin.mak',
  \            'mac': 'make',
  \            'linux': 'make',
  \            'unix': 'gmake'
  \     }
  \ }
NeoBundle 'tikhomirov/vim-glsl'
NeoBundle 'tpope/vim-dispatch'
NeoBundle 'tpope/vim-surround'
NeoBundle 'vim-airline/vim-airline'
NeoBundle 'vim-airline/vim-airline-themes'
NeoBundle 'xolox/vim-misc'
NeoBundleLazy 'vim-scripts/Conque-GDB', {
  \     'commands': [
  \         { 'name': 'ConqueGdb', 'complete': 'file' },
  \         { 'name': 'ConqueGdbSplit', 'complete': 'file' },
  \         { 'name': 'ConqueGdbVSplit', 'complete': 'file' },
  \         { 'name': 'ConqueGdbTab', 'complete': 'file' },
  \         { 'name': 'ConqueGdbExe', 'complete': 'file' },
  \         { 'name': 'ConqueGdbDelete', 'complete': '' },
  \         { 'name': 'ConqueGdbCommand', 'complete': '' },
  \         { 'name': 'ConqueTerm', 'complete': 'shellcmd' },
  \         { 'name': 'ConqueTermSplit', 'complete': 'shellcmd' },
  \         { 'name': 'ConqueTermVSplit', 'complete': 'shellcmd' },
  \         { 'name': 'ConqueTermTab', 'complete': 'shellcmd' }
  \     ]
  \ }
NeoBundleLazy 'Shougo/vimshell.vim', {
  \ 'commands' : [
  \         { 'name': 'VimShell', 'complete': 'customlist,vimshell#complete' },
  \         { 'name': 'VimShellCreate', 'complete': 'customlist,vimshell#complete' },
  \         { 'name': 'VimShellPop', 'complete': 'customlist,vimshell#complete' },
  \         { 'name': 'VimShellTab', 'complete': 'customlist,vimshell#complete' },
  \         { 'name': 'VimShellCurrentDir', 'complete': 'customlist,vimshell#complete' },
  \         { 'name': 'VimShellBufferDir', 'complete': 'customlist,vimshell#complete' },
  \         { 'name': 'VimShellExecute', 'complete': 'customlist,vimshell#helpers#vimshell_execute_complete' },
  \         { 'name': 'VimShellInteractive', 'complete': 'customlist,vimshell#helpers#vimshell_execute_complete' },
  \         { 'name': 'VimShellSendString' },
  \         { 'name': 'VimShellSendBuffer' },
  \         { 'name': 'VimShellClose' }
  \     ]
  \ }
NeoBundleLazy 'Valloric/YouCompleteMe', {
  \ 'augroup': 'youcompletemeStart',
  \ 'filetypes': ['c', 'cpp', 'python', 'cs', 'haskell', 'lua', 'java', 'rust'],
  \ 'build': {
  \           'windows': 'python install.py --clang-completer --racer-completer',
  \           'unix': './install.py --clang-completer --racer-completer',
  \           'mac': './install.py --clang-completer --racer-completer'
  \     }
  \ }

" OpenCL
NeoBundleLazy 'petRUShka/vim-opencl', { 'filetypes': 'opencl' }

" Haskell
NeoBundleLazy 'eagletmt/ghcmod-vim', { 'filetypes': 'haskell' }
NeoBundleLazy 'eagletmt/neco-ghc', { 'filetypes': 'haskell' }

" Java
NeoBundleLazy 'artur-shaik/vim-javacomplete2', { 'filetypes': 'java' }

" Lua
NeoBundleLazy 'xolox/vim-lua-ftplugin', { 'filetypes': 'lua' }

" LaTeX
NeoBundleLazy 'lervag/vimtex', { 'filetypes': 'tex' }

call neobundle#end()

" Filetype detection enable
filetype plugin indent on

" Check if we are missing plugin bundles
NeoBundleCheck

" ================ Plugins Conf ======================
set runtimepath+=$HOME/.vim/conf/plugins
for f in split(glob('~/.vim/conf/plugins/*.vim'), '\n')
    exe 'source' f
endfor
