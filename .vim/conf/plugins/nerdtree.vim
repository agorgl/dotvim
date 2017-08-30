""
"" NERDTree options
""

" Pretty arrows
let g:NERDTreeDirArrows = 1

" Ignore
let g:NERDTreeIgnore = ['\v[\/]\.(git|hg|svn)$[[dir]]', '\v(bin|lib|tmp|__pycache__)$[[dir]]', '\v\.(exe|so|dll|obj|o|class|pyc)$[[file]]']

" Close vim if the only window left open is a NERDTree
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
