"
" Term aliases
"
let s:term_buf = 0

fun! s:term_exit_cb(job, st)
    echo 'Exit Code: ' . a:st
    if a:st == 0 || a:st == 130
        execute "bd!" . s:term_buf
        let s:term_buf = 0
    endif
endfun

fun! s:term_run(cmd)
    tabnew
    let buf = term_start(a:cmd, {
      \ "curwin": v:true,
      \ "term_kill": "int",
      \ "exit_cb": function('s:term_exit_cb')
      \ })
    return buf
endfun

fun! RunTermCmd(cmd)
    let job = s:term_buf != 0 ? term_getjob(s:term_buf) : v:null
    if job == v:null || job_status(job) != "run"
        if s:term_buf != 0
            execute "bd!" . s:term_buf
            let s:term_buf = 0
        endif
        let pwin = win_getid()
        let tbuf = s:term_run(a:cmd)
        let s:term_buf = tbuf
        call win_gotoid(pwin)
    else
        echo 'Already running!'
    endif
endfun

fun! StopTermCmd()
    let job = s:term_buf != 0 ? term_getjob(s:term_buf) : v:null
    if job != v:null && job_status(job) == "run"
        "call term_sendkeys(s:term_buf, "\<c-c>")
        call job_stop(job, "int")
    else
        if s:term_buf != 0
            execute "bd!" . s:term_buf
            let s:term_buf = 0
        else
            echo 'Nothing to stop!'
        endif
    endif
endfun

map <Esc>[15;5~ <C-F5>
map <Esc>[15;2~ <S-F5>

nnoremap <silent> <F5> :call RunTermCmd(g:build_cmd)<CR>
nnoremap <silent> <C-F5> :call RunTermCmd(g:clean_cmd)<CR>
nnoremap <silent> <S-F5> :call StopTermCmd()<CR>

"
" Colorscheme aliases
"
let s:colorschemes = [
  \ 'molokai',
  \ 'badwolf',
  \ 'srcery',
  \ 'one',
  \ 'onedark',
  \ 'onehalfdark',
  \ 'sonokai',
  \ 'edge',
  \ 'tender',
  \ 'pencil',
  \ 'tokyonight',
  \ 'apprentice',
  \ 'lucius',
  \ 'jellybeans',
  \ 'dracula',
  \ 'deus',
  \ 'gruvbox',
  \ 'everforest',
  \ 'nord',
  \ ]

fun! CycleColorschemes()
    let i = index(s:colorschemes, g:colors_name)
    let j = (i + 1) % len(s:colorschemes)
    let next_colorscheme = s:colorschemes[j]
    exec 'colorscheme  ' . l:next_colorscheme
    colorscheme
endfun
nnoremap <silent> <F8> :call CycleColorschemes()<CR>
