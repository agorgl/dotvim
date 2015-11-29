""
"" Syntastic options
""

" Set ruby checker
let g:syntastic_ruby_checkers = ['mri', 'rubocop']

" Set error sign color to bg = SignColumn
exec 'hi SyntasticErrorSign guifg=#990000 ctermfg=1 ' .
            \' guibg=' . synIDattr(synIDtrans(hlID('SignColumn')), 'bg', 'gui') .
            \' ctermbg=' . synIDattr(synIDtrans(hlID('SignColumn')), 'bg', 'cterm')

" Set warning sign color to bg = SignColumn
exec 'hi SyntasticWarningSign guifg=#CECE00 ctermfg=11 ' .
            \' guibg=' . synIDattr(synIDtrans(hlID('SignColumn')), 'bg', 'gui') .
            \' ctermbg=' . synIDattr(synIDtrans(hlID('SignColumn')), 'bg', 'cterm')
