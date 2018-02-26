""
"" YouCompleteMe options
""

let g:ycm_error_symbol = '✘✘'                                       " Default: >>
let g:ycm_warning_symbol = '!!'                                     " Default: >>
let g:ycm_complete_in_comments = 1                                  " Default: 0
let g:ycm_extra_conf_vim_data = ['&filetype']                       " Default: []
let g:ycm_global_ycm_extra_conf = '~/.vim/conf/.ycm_extra_conf.py'  " Default: ''
let g:ycm_confirm_extra_conf = 1                                    " Default: 1
let g:ycm_extra_conf_globlist = ['~/.vim/conf/.ycm_extra_conf.py']  " Default: []
let g:ycm_goto_buffer_command = 'same-buffer'                       " Default: 'same-buffer'
" let g:ycm_semantic_triggers = {'haskell' : ['.']}
let g:ycm_rust_src_path = substitute(system('rustc --print sysroot'), '\n\+$', '', '') . '/lib/rustlib/src/rust/src'

" Force code intel
nnoremap <F8> :YcmForceCompileAndDiagnostics <CR>

" Go To Declaration
nnoremap <C-F12> :YcmCompleter GoToDeclaration <CR>

" Go To Definition
nnoremap <F12> :YcmCompleter GoToDefinition <CR>

" Set popup menu colors
exec 'hi Pmenu guifg=lightblue ' .
            \' guibg=' . synIDattr(synIDtrans(hlID('SignColumn')), 'bg', 'gui')
           " \ . ' ctermbg=' . synIDattr(synIDtrans(hlID('SignColumn')), 'bg', 'cterm')
