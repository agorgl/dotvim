""
"" CtrlP options
""
" Ignore
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.git|\.hg|\.svn|build|target|tmp)$',
  \ 'file': '\v\.(exe|so|dll|obj|o|class)$',
  \ }

" Faster file discovery
if executable('fd')
    let g:ctrlp_user_command = 'fd --type f --color=never "" %s'
    let g:ctrlp_use_caching = 0
endif

" Use cpsm matcher
let g:ctrlp_match_func = { 'match': 'cpsm#CtrlPMatch' }
