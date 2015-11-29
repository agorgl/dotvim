" Register NecoGHC completion
setlocal omnifunc=necoghc#omnifunc

" Force code intel
nnoremap <F8> :GhcModCheckAndLintAsync <CR>

" Analyse type
nnoremap <F12> :GhcModType <CR>
nnoremap <C-F12> :GhcModTypeClear <CR>
