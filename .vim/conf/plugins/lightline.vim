""-------------------------------------------------------------
"" Lightline
""-------------------------------------------------------------
" Always show a status line
set laststatus=2

" Main lightline configuration
let s:lightline = {
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
  \   'tabline': {
  \     'left': [['tabs']],
  \     'right': [[]]
  \   },
  \   'tabline_separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
  \   'tabline_subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" }
  \ }

let g:lightline = extend(get(g:, 'lightline', {}), s:lightline, "keep")

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
  " Pick first non empty
  let components = [mixed_component, trailing_component]
  for c in components
    if !empty(c)
      return c
    endif
  endfor
  return ''
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
" ColorScheme refresh
"
function! s:lightline_update()
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endfunction

augroup lightline_colorscheme_change
  autocmd!
  autocmd ColorScheme * call s:lightline_update()
augroup END
