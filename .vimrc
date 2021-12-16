"--------------------------------------------------------------
" Sections:
"   -> Plugins Manager Setup
"   -> General
"   -> Internal Plugins
"   -> Installed Plugins
"   -> User Interface
"   -> Colors and Fonts
"   -> Misc
"   -> Helper functions
"   -> Plugins Configuration
"   -> User Scripts
"--------------------------------------------------------------

"--------------------------------------------------------------
" => Plugins Manager Setup (Vim-Plug)
"--------------------------------------------------------------
if has('vim_starting')
    " Use Vim settings, rather then Vi settings (much better!).
    " This must be first, because it changes other options as a side effect.
    set nocompatible
endif

if has('win32') || has('win64')
    " Set the vim user folder in Windows to the %USERPROFILE%/.vim/
    set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif

let vimplug_exists = expand('~/.vim/autoload/plug.vim')
if !filereadable(vimplug_exists)
    let vimplug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    echom "Installing Vim-Plug..."
    if executable('curl')
        exec '!curl -fLo ' . expand('~/.vim/autoload/plug.vim') . ' --create-dirs ' . vimplug_url
    elseif executable('wget')
        call mkdir(fnamemodify('~/.vim/autoload/plug.vim', ':h'), 'p')
        exec '!wget --force-directories --no-check-certificate -O ' . expand('~/.vim/autoload/plug.vim') . ' ' . vimplug_url
    else
        echom 'Could not download plugin manager. No plugins were installed'
        finish
    endif
    autocmd VimEnter * PlugInstall
endif

"--------------------------------------------------------------
" => General
"--------------------------------------------------------------
set nowrap                     " Don't wrap lines
set autoread                   " Reload files changed outside vim
set backspace=indent,eol,start " Allow backspace in insert mode
set number                     " Show line numbers
set showcmd                    " Show incomplete cmds down the bottom
set showmode                   " Show current mode down the bottom
set hlsearch                   " Highlight search terms
set incsearch                  " Show search matches as you type
set mouse=a                    " Enable mouse in terminals supporting it

" No sounds
set noerrorbells
set visualbell
set t_vb=
autocmd GUIEnter * set visualbell t_vb=

" Filetype detection enable
filetype plugin indent on

" Enable syntax highlighting
syntax on

" Enable useful autocomplete for commands
set wildmenu
set wildmode=list:longest,list:full

" Completion
set completeopt-=preview " Remove preview window from autocompletion
set pumheight=12         " Set max height for popup window

" Turn off swap and backup files
set noswapfile
set nobackup
set nowb

" Indentation
set autoindent    " Copy indent from current line when starting a new line
set smartindent   " Do smart autoindenting when starting a new line
set smarttab      " When on, a <Tab> in front of a line inserts blanks according to 'shiftwidth'
set shiftwidth=4  " Number of spaces to use for each step of (auto)indent
set softtabstop=4 " Number of spaces that a <Tab> counts for while performing editing operations
set tabstop=4     " Number of spaces that a <Tab> in the file counts for
set expandtab     " Spaces instead of tabs

" Natural splits
set splitbelow
set splitright

" More frequent updates for, e.g. signs.
set updatetime=300

" Uniform copy paste between systemms
if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
endif

" Ensure Vim starts with a server
if empty(v:servername) && exists('*remote_startserver') && ($STY != "")
  call remote_startserver('VIM')
endif

"--------------------------------------------------------------
" => Internal Plugins
"--------------------------------------------------------------
" Debugger plugin
packadd termdebug

"--------------------------------------------------------------
" => Installed Plugins
"--------------------------------------------------------------
" Start plugin handling
call plug#begin('~/.vim/bundle')

"
" -# Interface #-
"
" A tree explorer
Plug 'scrooloose/nerdtree'
" A light and configurable statusline/tabline plugin for Vim
Plug 'itchyny/lightline.vim'
" A command-line fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" A bundle of fzf-based commands and mappings
Plug 'junegunn/fzf.vim'
" View and search LSP symbols, tags
Plug 'liuchengxu/vista.vim'
" Terminal manager for vim
Plug 'voldikss/vim-floaterm'
" Copy text from anywhere with OSC52
Plug 'ojroques/vim-oscyank'

"
" -# Themes #-
"
" Molokai
Plug 'tomasr/molokai'
" Badwolf
Plug 'sjl/badwolf'
" Srcery
Plug 'srcery-colors/srcery-vim'
" Onedark
Plug 'joshdick/onedark.vim'
" Onehalf
Plug 'sonph/onehalf', { 'rtp': 'vim' }
" Sonokai
Plug 'sainnhe/sonokai'
" Edge
Plug 'sainnhe/edge'
" Tender
Plug 'jacoborus/tender.vim'
" Pencil
Plug 'reedes/vim-colors-pencil'
" Tokyo Night
Plug 'ghifarit53/tokyonight-vim'
" Apprentice
Plug 'romainl/Apprentice'
" Lucius
Plug 'jonathanfilip/vim-lucius'
" Jellybeans
Plug 'nanotech/jellybeans.vim'

"
" -# Editing #-
"
" Insert or delete brackets, parens, quotes in pair
Plug 'jiangmiao/auto-pairs'
" Provides mappings to easily delete, change and add surroundings in pairs
Plug 'tpope/vim-surround'
" Shows a git diff in the gutter (sign column) and stages/undoes hunks.
Plug 'airblade/vim-gitgutter'
" Alignment plugin
Plug 'junegunn/vim-easy-align'
" Intensely orgasmic commenting
Plug 'tpope/vim-commentary'
" Snippet plugin
Plug 'SirVer/ultisnips'
" Markdown preview plugin
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm install' }
" ASCII box drawing plugin
Plug 'gyim/vim-boxdraw'

"
" -# Tools #-
"
" Run async shell commands and output to quickfix window
Plug 'skywind3000/asyncrun.vim'
" Git wrapper
Plug 'tpope/vim-fugitive'
" Easy code formatting by integrating existing code formatters
Plug 'Chiel92/vim-autoformat'
" Run your tests at the speed of thought
Plug 'vim-test/vim-test'
" A REST console for Vim
Plug 'diepm/vim-rest-console'

"
" -# Completion Engine #-
"
" Complete engine and Language Server support
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'yami-beta/asyncomplete-omni.vim'
Plug 'micchy326/lightline-lsp-progress'

"
" -# Languages #-
"
" A collection of language packs for Vim
Plug 'sheerun/vim-polyglot'
" LaTeX support plugin
Plug 'lervag/vimtex', { 'for': 'tex' }
" Flutter support plugin
Plug 'thosakwe/vim-flutter', { 'for': 'dart' }

" End plugin handling
call plug#end()

"--------------------------------------------------------------
" => User Interface
"--------------------------------------------------------------
if has("gui_running")
    "Strip unwanted window stuff
    set guioptions-=m " Remove menu bar
    set guioptions-=T " Remove toolbar
    set guioptions-=r " Remove right-hand scroll bar
    set guioptions-=L " Remove left-hand scroll bar
endif

if has('win32') || has('win64')
    au GUIEnter * simalt ~x " Maximize gVim window
endif

"--------------------------------------------------------------
" => Colors and Fonts
"--------------------------------------------------------------
" Set utf-8 as standard encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8

" Unix line endings
set fileformats=unix,dos
set nofixendofline

" Enable true colors
if has("termguicolors")
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

" Set the GUI mode font
if has('win32') || has('win64')
    set guifont=Consolas\ NF,Consolas:h10
elseif has('gui_gtk2') || has('gui_gtk3')
    set guifont=Terminus\ 11
endif

" Set the color scheme
if isdirectory(g:plug_home)
    colorscheme molokai
endif

" Enable DirectX rendering in Windows
if has('win32') || has('win64')
    set rop=type:directx,geom:1,taamode:1
endif

"--------------------------------------------------------------
" => Misc
"--------------------------------------------------------------
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Make yanking with capital Y behave like the other capital letters
nnoremap Y y$

" Easier copy paste mappings
noremap YY "+y
noremap PP "+p

" Navigate through tabs
nnoremap <silent> <Esc>n :tabnext<CR>
nnoremap <silent> <Esc>p :tabprev<CR>
tnoremap <silent> <Esc>n <C-W>:tabnext<CR>
tnoremap <silent> <Esc>p <C-W>:tabprev<CR>

"--------------------------------------------------------------
" => Helper functions
"--------------------------------------------------------------
" Trims trailing whitespace
fun! TrimWhitespace()
    let l:save_cursor = getpos('.')
    %s/\s\+$//e
    call setpos('.', l:save_cursor)
endfun

" Converts to Unix line endings
fun! MakeUnixLineEndings()
    let l:save_cursor = getpos('.')
    %s/\r\(\n\)/\1/g
    call setpos('.', l:save_cursor)
endfun

" Converts to snake_case
fun! ToSnakeCase()
    :s#\C\(\<\u[a-z0-9]\+\|[a-z0-9]\+\)\(\u\)#\l\1_\l\2#g
endfun

" Converts to camelCase
fun! ToCamelCase()
    :s#_\(\l\)#\u\1#g
endfun

" Converts to CapitalCamelCase
fun! ToCapitalCamelCase()
    :s#\(\%(\<\l\+\)\%(_\)\@=\)\|_\(\l\)#\u\1\2#g
endfun

"--------------------------------------------------------------
" => Plugins Configuration
"--------------------------------------------------------------
if isdirectory(g:plug_home)
    set runtimepath+=$HOME/.vim/conf/plugins
    for f in split(glob('~/.vim/conf/plugins/*.vim'), '\n')
        exe 'source' f
    endfor
endif

"--------------------------------------------------------------
" => User Scripts
"--------------------------------------------------------------
set runtimepath+=$HOME/.vim/conf/scripts
for f in split(glob('~/.vim/conf/scripts/*.vim'), '\n')
    exe 'source' f
endfor
