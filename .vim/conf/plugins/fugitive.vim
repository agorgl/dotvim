""-------------------------------------------------------------
"" Fugitive
""-------------------------------------------------------------
" Async push and fetch
command! -bang -bar -nargs=* Gpush execute 'AsyncRun<bang> -cwd=' .
          \ fnameescape(FugitiveGitDir()) 'git push' <q-args>
command! -bang -bar -nargs=* Gfetch execute 'AsyncRun<bang> -cwd=' .
          \ fnameescape(FugitiveGitDir()) 'git fetch' <q-args>

" Open in new tab
nnoremap <silent> <F7> :<C-U>tab G<CR>
