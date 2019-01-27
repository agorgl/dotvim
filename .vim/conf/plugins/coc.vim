""-------------------------------------------------------------
"" CoC
""-------------------------------------------------------------
let b:tmp_dir = fnamemodify(fnamemodify(tempname(), ':p:h'), ':h')

call coc#config('coc.preferences', {
  \   'diagnostic.errorSign': '✘✘',
  \   'diagnostic.warningSign': '!!',
  \   'diagnostic.infoSign': '--',
  \   'diagnostic.hintSign': '**'
  \ })

call coc#config('languageserver', {
  \   'ccls': {
  \     "command": "ccls",
  \     "args": ["-v=1", "-log-file=" . b:tmp_dir . "/ccls.log"],
  \     "trace.server": "verbose",
  \     "filetypes": ["c", "cpp", "objc", "objcpp"],
  \     "rootPatterns": [".git/", "src/", "Makefile"],
  \     "initializationOptions": {
  \       "cacheDirectory": b:tmp_dir . "/ccls-cache",
  \       "compilationDatabaseCommand": expand("$HOME/.vim/conf/make_compile_db.py")
  \     }
  \   }
  \ })

" Don't give |ins-completion-menu| messages.
set shortmess+=c

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use `[c` and `]c` for navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Fix autofix problem of current line
nmap <leader>qf <Plug>(coc-fix-current)

" Overwrite highlight groups
hi default link CocHighlightText IncSearch

" Set popup menu colors
exec 'hi Pmenu guifg=lightblue ' .
         \   ' guibg='   . synIDattr(synIDtrans(hlID('SignColumn')), 'bg', 'gui')
       " \ . ' ctermbg=' . synIDattr(synIDtrans(hlID('SignColumn')), 'bg', 'cterm')

" Airline integration
let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'
