""-------------------------------------------------------------
"" FZF
""-------------------------------------------------------------
" Commands
command! CtrlP execute (len(system('git rev-parse'))) ? ':Files' : ':GFiles --cached --others --exclude-standard'

" Mappings
nnoremap <silent> <C-P>  :<C-U>CtrlP<CR>
nnoremap <silent> <C-T>  :<C-U>Vista finder<CR>
nnoremap <silent> <F3>   :<C-U>Rg<CR>
