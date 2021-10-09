""-------------------------------------------------------------
"" vim-test
""-------------------------------------------------------------
" Make test commands execute using embedded vim terminal
let test#strategy = "vimterminal"

" Mapping to run closest test
nmap <silent> t<C-n> :TestNearest<CR>
