""
"" Syntastic options
""
" Always stick any detected errors into the loclist
let g:syntastic_always_populate_loc_list=1

" Set ruby checker
let g:syntastic_ruby_checkers = ['mri', 'rubocop']

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
exec 'hi SyntasticErrorSign guifg=#990000 ctermfg=1 ' .
            \' guibg=' . g:cur_gui_bg_col .
            \' ctermbg=' . g:cur_term_bg_col

" Set warning sign color to bg = SignColumn
exec 'hi SyntasticWarningSign guifg=#CECE00 ctermfg=11 ' .
            \' guibg=' . g:cur_gui_bg_col .
            \' ctermbg=' . g:cur_term_bg_col

unlet g:cur_gui_bg_col
unlet g:cur_term_bg_col
