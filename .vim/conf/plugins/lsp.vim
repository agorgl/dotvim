""-------------------------------------------------------------
"" Lsp
""-------------------------------------------------------------
" Tmp directory path
let g:tmp_dir = fnamemodify(fnamemodify(tempname(), ':p:h'), ':h')
" Lsp script path
let g:lsp_dir = expand('$HOME/.vim/conf/plugins/lsp/')

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
      \     'compilationDatabaseCommand': expand('$HOME/.vim/conf/plugins/lsp/make_compile_db.py')
      \   },
      \ 'whitelist': ['c', 'cc', 'cpp', 'objc', 'objcpp'],
      \ })
endif

" Rust language server
if executable('rls')
    " rustup component add rls rust-analysis rust-src
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rust-analyzer']},
        \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'Cargo.toml'))},
        \ 'initialization_options': {
        \   'cargo': {
        \     'loadOutDirsFromCheck': v:true
        \     },
        \   'procMacro': {
        \     'enable': v:true
        \     }
        \   },
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

" Java language server
if executable('jdtls')
    " Install from distro repositories || build it from source
    let g:jdtls_script = g:lsp_dir . 'jdtls' . (has('win32') ? '.bat' : '.sh')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'jdtls',
        \ 'cmd': {server_info->[g:jdtls_script, lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), '.git/..')]},
        \ 'whitelist': ['java'],
        \ })
endif

" Javascript/Typescript language server
if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'typescript-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
        \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'package.json'))},
        \ 'whitelist': ['javascript', 'javascript.jsx', 'javascriptreact', 'typescript', 'typescript.tsx', 'typescriptreact'],
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

" Fix markdown inside preview popup
autocmd FileType markdown.lsp-hover
	\ nmap <silent><buffer>q :pclose<CR>| doautocmd <nomodeline> BufWinEnter

" Setup signs
let g:lsp_signs_error       = {'text': '✘✘'}
let g:lsp_signs_warning     = {'text': '!!'}
let g:lsp_signs_information = {'text': '--'}
let g:lsp_signs_hint        = {'text': '**'}

" Tab completion
imap <c-space> <Plug>(asyncomplete_force_refresh)
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

fun! s:setup_mappings()
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

    " Show popup with info on the item under the cursor
    nmap <silent> K <plug>(lsp-hover)
endfun

fun! s:setup_popup_colors()
    let synID = synIDtrans(hlID('SignColumn'))
    let pmenu_guibg = synIDattr(l:synID, 'bg', 'gui')
    let pmenu_ctermbg = synIDattr(l:synID, 'bg', 'cterm')

    exec 'hi Pmenu guifg=lightblue ' .
             \   ' guibg='   . (!empty(l:pmenu_guibg) ? l:pmenu_guibg : 'NONE')
             \ . ' ctermbg=' . (!empty(l:pmenu_ctermbg) ? l:pmenu_ctermbg : 'NONE')
endfun

fun! s:setup_background_colors()
    " Let background colors be the same as the background of our current theme
    let cur_gui_bg_col = synIDattr(synIDtrans(hlID('SignColumn')), 'bg', 'gui')
    if empty(l:cur_gui_bg_col)
        let cur_gui_bg_col = "NONE"
    endif
    let cur_term_bg_col = synIDattr(synIDtrans(hlID('SignColumn')), 'bg', 'cterm')
    if empty(l:cur_term_bg_col)
        let cur_term_bg_col = "NONE"
    endif

    " Set error sign color to bg = SignColumn
    exec 'hi LspErrorText guifg=#990000 ctermfg=1 ' .
                \' guibg=' . l:cur_gui_bg_col .
                \' ctermbg=' . l:cur_term_bg_col

    " Set warning sign color to bg = SignColumn
    exec 'hi LspWarningText guifg=#DFAF00 ctermfg=11 ' .
                \' guibg=' . l:cur_gui_bg_col .
                \' ctermbg=' . l:cur_term_bg_col

    " Set info sign color to bg = SignColumn
    exec 'hi LspInformationText guifg=#00CECE ctermfg=14 ' .
                \' guibg=' . l:cur_gui_bg_col .
                \' ctermbg=' . l:cur_term_bg_col

    " Set hint sign color to bg = SignColumn
    exec 'hi LspHintText guifg=#C0C0C0 ctermfg=7 ' .
                \' guibg=' . l:cur_gui_bg_col .
                \' ctermbg=' . l:cur_term_bg_col
endfun

call s:setup_mappings()
call s:setup_popup_colors()
call s:setup_background_colors()
