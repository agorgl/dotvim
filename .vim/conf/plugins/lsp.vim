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
      \     'compilationDatabaseCommand': g:lsp_dir . 'make_compile_db.py'
      \   },
      \ 'whitelist': ['c', 'cc', 'cpp', 'objc', 'objcpp'],
      \ })
endif

" Rust language server
if executable('rust-analyzer')
    " Install from distro repositories || build it from source
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rust-analyzer',
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

    function! s:rust_analyzer_apply_source_change(context)
        let l:command = get(a:context, 'command', {})

        let l:workspace_edit = get(l:command['arguments'][0], 'workspaceEdit', {})
        if !empty(l:workspace_edit)
            call lsp#utils#workspace_edit#apply_workspace_edit(l:workspace_edit)
        endif

        let l:cursor_position = get(l:command['arguments'][0], 'cursorPosition', {})
        if !empty(l:cursor_position)
            call cursor(lsp#utils#position#lsp_to_vim('%', l:cursor_position))
        endif
    endfunction
    call lsp#register_command('rust-analyzer.applySourceChange', function('s:rust_analyzer_apply_source_change'))
endif

" Haskell language server
if executable('haskell-language-server-wrapper')
    " ghcup install hls
    au User lsp_setup call lsp#register_server({
        \ 'name': 'haskell-language-server-wrapper',
        \ 'cmd': {server_info->['haskell-language-server-wrapper', '--lsp']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(),
        \     ['.cabal', 'stack.yaml', 'cabal.project', 'package.yaml', 'hie.yaml', '.git'],
        \   ))},
        \ 'whitelist': ['haskell', 'lhaskell'],
        \ })
endif

" Go language server
if executable('gopls')
    " Install from distro repositories || build it from source
    au User lsp_setup call lsp#register_server({
        \ 'name': 'gopls',
        \ 'cmd': {server_info->['gopls']},
        \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'go.mod'))},
        \ 'initialization_options': {
        \   'completeUnimported': v:true,
        \   'matcher': 'fuzzy',
        \   'codelenses': {
        \     'generate': v:true,
        \     'test': v:true,
        \     },
        \   },
        \ 'allowlist': ['go', 'gomod'],
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
if executable('jdtls') || isdirectory(glob('~/.local/opt/jdtls'))
    " Install from distro repositories || build it from source
    let g:jdtls_script = g:lsp_dir . 'jdtls' . (has('win32') ? '.bat' : '.sh')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'jdtls',
        \ 'cmd': {server_info->[g:jdtls_script, lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), '.git/..')]},
        \ 'workspace_config': {
        \     'java': {
        \       'format': {
        \         'settings': {
        \           'url': lsp#utils#path_to_uri(g:lsp_dir . 'eclipse-java-style.xml'),
        \         },
        \         'comments': {
        \           'enabled': v:false,
        \         },
        \       }
        \     }
        \   },
        \ 'whitelist': ['java'],
        \ })
    au User lsp_setup call lsp#register_command(
        \ 'java.apply.workspaceEdit',
        \ {ctx -> lsp#utils#workspace_edit#apply_workspace_edit(ctx['command']['arguments'][0])}
        \ )
endif

" Javascript/Typescript language server
if executable('typescript-language-server')
    " npm i typescript-language-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'typescript-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
        \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'package.json'))},
        \ 'whitelist': ['javascript', 'javascript.jsx', 'javascriptreact', 'typescript', 'typescript.tsx', 'typescriptreact'],
        \ })
endif

" YAML language server
if executable('yaml-language-server')
   au User lsp_setup call lsp#register_server({
        \ 'name': 'yaml-language-server',
        \ 'cmd': {server_info->['yaml-language-server', '--stdio']},
        \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), '.git/..'))},
        \ 'whitelist': ['yaml.kubernetes'],
        \ 'workspace_config': {
        \   'yaml': {
        \     'validate': v:true,
        \     'hover': v:true,
        \     'completion': v:true,
        \     'customTags': [],
        \     'schemas': {
        \       'kubernetes': ["/*.yaml", "/*.yml"],
        \     },
        \     'schemaStore': {
        \       'url': 'https://www.schemastore.org/json/',
        \       'enable': v:true
        \       },
        \     }
        \   }
        \ })
endif

" TailwindCSS language server
if executable('tailwindcss-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'tailwindcss-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'tailwindcss-language-server --stdio']},
        \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tailwind.config.js'))},
        \ 'initialization_options': {},
        \ 'whitelist': ['css', 'less', 'sass', 'scss', 'vue'],
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
let g:lsp_work_done_progress_enabled = 1
let g:asyncomplete_log_file = g:tmp_dir . '/asyncomplete.log'

" Enable signs
let g:lsp_signs_enabled = 1
let g:lsp_diagnostics_signs_priority = 11
let g:lsp_document_code_action_signs_enabled = 0

" Enable echo under cursor when in normal mode
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_diagnostics_float_cursor = 1

" Fix markdown inside preview popup
autocmd FileType markdown.lsp-hover
	\ nmap <silent><buffer>q :pclose<CR>| doautocmd <nomodeline> BufWinEnter

" Setup signs
let g:lsp_diagnostics_signs_error       = {'text': '✘✘'}
let g:lsp_diagnostics_signs_warning     = {'text': '!!'}
let g:lsp_diagnostics_signs_information = {'text': '--'}
let g:lsp_diagnostics_signs_hint        = {'text': '**'}

" Tab completion
imap <c-space> <Plug>(asyncomplete_force_refresh)
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

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

call s:setup_popup_colors()
call s:setup_background_colors()

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif

    nmap <buffer> gd <Plug>(lsp-definition)
    nmap <buffer> gr <Plug>(lsp-references)
    nmap <buffer> gi <Plug>(lsp-implementation)
    nmap <buffer> gt <Plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <Plug>(lsp-rename)
    nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
    nmap <buffer>  K <Plug>(lsp-hover)
    nmap <buffer> qf <Plug>(lsp-code-action)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go,*.hs,*.py,*.java call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
    au!
    " Run only for languages a server is registered
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
