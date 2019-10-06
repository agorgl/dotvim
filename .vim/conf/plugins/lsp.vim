""-------------------------------------------------------------
"" Lsp
""-------------------------------------------------------------
" Tmp directory path
let g:tmp_dir = fnamemodify(fnamemodify(tempname(), ':p:h'), ':h')

" C language server
if executable('ccls')
    " Install from distro repositories || build it from source
    au User lsp_setup call lsp#register_server({
      \ 'name': 'ccls',
      \ 'cmd': {server_info->['ccls', '-v=1', '-log-file=' . g:tmp_dir . '/ccls.log']},
      \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), '.git/..'))},
      \ 'initialization_options': {
      \     'cache': {'directory': g:tmp_dir . '/ccls-cache'},
      \     'completion': {'detailedLabel': v:false},
      \     'compilationDatabaseCommand': expand('$HOME/.vim/conf/make_compile_db.py')
      \   },
      \ 'whitelist': ['c', 'cc', 'cpp', 'objc', 'objcpp'],
      \ })
endif

" Rust language server
if executable('rls')
    " rustup component add rls rust-analysis rust-src
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
        \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'Cargo.toml'))},
        \ 'whitelist': ['rust'],
        \ })
endif

" Python language server
if executable('pyls')
    " pip install python-language-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
endif

" Elixir language server
if executable('elixir-ls')
    " Install from repository
    au User lsp_setup call lsp#register_server({
        \ 'name': 'elixir-ls',
        \ 'cmd': {server_info->['elixir-ls']},
        \ 'whitelist': ['elixir'],
        \ })
endif

" Omnicompletion source
call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
        \ 'name': 'omni',
        \ 'whitelist': ['tex'],
        \ 'blacklist': [],
        \ 'completor': function('asyncomplete#sources#omni#completor')
        \  }))

" Debugging
let g:lsp_log_verbose = 1
let g:lsp_log_file = g:tmp_dir . '/vim-lsp.log'
let g:asyncomplete_log_file = g:tmp_dir . '/asyncomplete.log'

" Enable signs
let g:lsp_signs_enabled = 1

" Enable echo under cursor when in normal mode
let g:lsp_diagnostics_echo_cursor = 1

" Tab completion
imap <c-space> <Plug>(asyncomplete_force_refresh)
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" Use <c-space> to trigger completion.
imap <c-space> <Plug>(asyncomplete_force_refresh)

" Use `[c` and `]c` for navigate diagnostics
nmap <silent> [c <Plug>(lsp-previous-error)
nmap <silent> ]c <Plug>(lsp-next-error)

" Remap keys for gotos
nmap <silent> gd <Plug>(lsp-definition)
nmap <silent> gy <Plug>(lsp-type-definition)
nmap <silent> gi <Plug>(lsp-implementation)
nmap <silent> gr <Plug>(lsp-references)

" Remap for rename current word
nmap <leader>rn <Plug>(lsp-rename)

" Fix autofix problem of current line
nmap <leader>qf <Plug>(lsp-code-action)

" Setup signs
let g:lsp_signs_error       = {'text': '✘✘'}
let g:lsp_signs_warning     = {'text': '!!'}
let g:lsp_signs_information = {'text': '--'}
let g:lsp_signs_hint        = {'text': '**'}

" Set popup menu colors
let s:synID = synIDtrans(hlID('SignColumn'))
let s:pmenu_guibg = synIDattr(s:synID, 'bg', 'gui')
let s:pmenu_ctermbg = synIDattr(s:synID, 'bg', 'cterm')

exec 'hi Pmenu guifg=lightblue ' .
         \   ' guibg='   . (!empty(s:pmenu_guibg) ? s:pmenu_guibg : 'none')
         \ . ' ctermbg=' . (!empty(s:pmenu_ctermbg) ? s:pmenu_ctermbg : 'none')

unlet s:pmenu_ctermbg
unlet s:pmenu_guibg
unlet s:synID

" Let background colors be the same as the background of our current theme
let g:cur_gui_bg_col = synIDattr(synIDtrans(hlID('SignColumn')), 'bg', 'gui')
if empty(g:cur_gui_bg_col)
    let g:cur_gui_bg_col = "none"
endif
let g:cur_term_bg_col = synIDattr(synIDtrans(hlID('SignColumn')), 'bg', 'cterm')
if empty(g:cur_term_bg_col)
    let g:cur_term_bg_col = "none"
endif

" Set error sign color to bg = SignColumn
exec 'hi LspErrorText guifg=#990000 ctermfg=1 ' .
            \' guibg=' . g:cur_gui_bg_col .
            \' ctermbg=' . g:cur_term_bg_col

" Set warning sign color to bg = SignColumn
exec 'hi LspWarningText guifg=#DFAF00 ctermfg=11 ' .
            \' guibg=' . g:cur_gui_bg_col .
            \' ctermbg=' . g:cur_term_bg_col

" Set info sign color to bg = SignColumn
exec 'hi LspInformationText guifg=#00CECE ctermfg=14 ' .
            \' guibg=' . g:cur_gui_bg_col .
            \' ctermbg=' . g:cur_term_bg_col

" Set hint sign color to bg = SignColumn
exec 'hi LspHintText guifg=#C0C0C0 ctermfg=7 ' .
            \' guibg=' . g:cur_gui_bg_col .
            \' ctermbg=' . g:cur_term_bg_col

unlet g:cur_gui_bg_col
unlet g:cur_term_bg_col
