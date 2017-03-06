""
"" vim-autoformat options
""
" Disable the fallback to vim's indent file, retabbing and removing trailing whitespace
let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 0

" Setup custom C formatter using custom clang-format config
let g:clang_fmt_config_file = expand("~/.vim/conf/data/.clang-format")
let g:formatdef_custom_cf = "'clang-format -lines=' . a:firstline . ':' . a:lastline . ' --assume-filename=\"' . g:clang_fmt_config_file . '\" -style=file'"
let g:formatters_c = ['custom_cf']
