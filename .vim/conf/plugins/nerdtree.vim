""
"" NERDTree options
""

" Pretty arrows
let g:NERDTreeDirArrows = 1

" Ignore
let g:NERDTreeIgnore = [
  \ '\v[\/]\.(git|hg|svn)$[[dir]]',
  \ '\v(bin|lib|tmp|build|target|__pycache__)$[[dir]]',
  \ '\v\.(exe|so|dll|obj|o|class|pyc)$[[file]]'
  \ ]

" Map toggle
nnoremap <silent> <F2> :<C-U>NERDTreeToggle<CR>

" Close vim if the only window left open is a NERDTree
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
