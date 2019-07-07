""-------------------------------------------------------------
"" Lightline
""-------------------------------------------------------------
" Always show a status line
set laststatus=2

" Main lightline configuration
let g:lightline = {
  \   'colorscheme': 'deus',
  \   'active': {
  \     'left': [['mode', 'paste'], ['gitbranch', 'readonly', 'filename', 'modified']],
  \     'right': [['trailing'], ['percent', 'lineinfo'], ['filetype', 'fileencoding', 'fileformat']]
  \   },
  \   'component': {
  \     'percent': '%p%%',
  \     'lineinfo': '%l:%-v'
  \   },
  \   'component_expand': {
  \     'trailing': 'LightlineTrailingWhitespaceComponent'
  \   },
  \   'component_function': {
  \     'gitbranch': 'fugitive#head',
  \   },
  \   'component_type': {
  \     'trailing': 'warning',
  \   },
  \   'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
  \   'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },
  \   'tabline_separator': { 'left': "\ue0b8", 'right': "\ue0be" },
  \   'tabline_subseparator': { 'left': "\ue0b9", 'right': "\ue0b9" }
  \ }

"
" Trailing whitespace component
"
function! LightlineTrailingWhitespaceComponent()
  let match = search('\s$', 'nw')
  return match != 0 ? '[' . match . ']' . 'trailing' : ''
endfunction

function! s:lightline_trailing_whitespace_refresh()
  if get(b:, 'lightline_trailing_whitespace_changedtick', 0) == b:changedtick
    return
  endif
  unlet! b:lightline_trailing_whitespace_changedtick
  call lightline#update()
  let b:lightline_trailing_whitespace_changedtick = b:changedtick
endfunction

augroup lightline_trailing_whitespace
  autocmd!
  autocmd CursorHold,BufWritePost * call s:lightline_trailing_whitespace_refresh()
augroup END

"
" CtrlP integration
"
let g:ctrlp_status_func = {
  \ 'main': 'CtrlPStatusFunc1',
  \ 'prog': 'CtrlPStatusFunc2',
  \ }

function! CtrlPStatusFunc1(focus, byfname, regex, prev, item, next, marked)
  let g:lightline.ctrlp_regex = a:regex
  let g:lightline.ctrlp_prev = a:prev
  let g:lightline.ctrlp_item = a:item
  let g:lightline.ctrlp_next = a:next
  return lightline#statusline(0)
endfunction

function! CtrlPStatusFunc2(str)
  return lightline#statusline(0)
endfunction
