"
" Term aliases
"
let s:term_buf = 0

fun! s:term_exit_cb(job, st)
    echo 'Exit Code: ' . a:st
    if a:st == 0 || a:st == 130
        execute "bd!" . s:term_buf
    endif
    let s:term_buf = 0
endfun

fun! s:term_run(cmd)
    let buf = term_start(a:cmd, {
      \ "term_rows": 10,
      \ "term_kill": "int",
      \ "exit_cb": function('s:term_exit_cb')
      \ })
    return buf
endfun

fun! RunTermCmd(cmd)
    if !s:term_buf
        let pwin = winnr()
        let tbuf = s:term_run(a:cmd)
        let s:term_buf = tbuf
        execute pwin . "wincmd w"
    endif
endfun

fun! StopTermCmd()
    if s:term_buf
        "execute "bd!" . s:term_buf
        call term_sendkeys(s:term_buf, "\<c-c>")
    endif
endfun

map <Esc>[15^ <C-F5>
map <Esc>[28~ <S-F5>

nnoremap <silent> <F5> :call RunTermCmd(g:build_cmd)<CR>
nnoremap <silent> <C-F5> :call RunTermCmd(g:clean_cmd)<CR>
nnoremap <silent> <S-F5> :call StopTermCmd()<CR>
