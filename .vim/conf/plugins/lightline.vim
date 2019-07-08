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
  \     'right': [['whitespace'], ['percent', 'lineinfo'], ['filetype', 'fileencoding', 'fileformat']]
  \   },
  \   'component': {
  \     'percent': '%p%%',
  \     'lineinfo': '%l:%-v'
  \   },
  \   'component_expand': {
  \     'whitespace': 'LightlineWhitespaceComponent'
  \   },
  \   'component_function': {
  \     'gitbranch': 'fugitive#head',
  \   },
  \   'component_type': {
  \     'whitespace': 'warning',
  \   },
  \   'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
  \   'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },
  \   'tabline_separator': { 'left': "\ue0b8", 'right': "\ue0be" },
  \   'tabline_subseparator': { 'left': "\ue0b9", 'right': "\ue0b9" }
  \ }

"
" Whitespace component
"
function! LightlineWhitespaceComponent()
  " Check for trailing whitespace
  " Must not have space after the last non-whitespace character
  let trailing = search('\s$', 'nw')
  let trailing_component = trailing != 0 ? '[' . trailing . ']' . 'trailing' : ''
  " Check for mixed indent
  " Must be all spaces or all tabs before the first non-whitespace character
  let mixed_indent = search('\v(^\t+ +)|(^ +\t+)', 'nw')
  let mixed_component = mixed_indent != 0 ? '[' . mixed_indent . ']' . 'mixed indent' : ''
  " Combine
  return join([mixed_component, trailing_component], ' ')
endfunction

function! s:lightline_whitespace_refresh()
  if get(b:, 'lightline_whitespace_changedtick', 0) == b:changedtick
    return
  endif
  unlet! b:lightline_whitespace_changedtick
  call lightline#update()
  let b:lightline_whitespace_changedtick = b:changedtick
endfunction

augroup lightline_whitespace
  autocmd!
  autocmd CursorHold,BufWritePost * call s:lightline_whitespace_refresh()
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
