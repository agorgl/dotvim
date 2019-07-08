""-------------------------------------------------------------
"" AsyncRun
""-------------------------------------------------------------
let s:quickfix_size = 8

fun s:on_asyncrun_start()
    call QuickfixToggle(s:quickfix_size, 1)
endfun

fun s:on_asyncrun_stop()
    if g:asyncrun_status == 'success'
        call QuickfixToggle(s:quickfix_size, 0)
    endif
endfun

augroup AsyncRun
    autocmd!
    autocmd User AsyncRunStart call s:on_asyncrun_start()
    autocmd User AsyncRunStop  call s:on_asyncrun_stop()
augroup End

function! QuickfixToggle(size, ...)
    let l:mode = a:1

    " Skip action in case we ask to open/close qf and is already open/closed
    let l:quickfix_open = len(filter(range(1, winnr('$')), 'getwinvar(v:val, "&ft") == "qf"'))
    if (l:mode == 1 && l:quickfix_open == 1) || (l:mode == 0 && l:quickfix_open == 0)
        return
    endif

    if l:mode == 1
        " Save working window number and state
        let s:async_run_winnr = winnr()
        let w:quickfix_save = winsaveview()
        " Open quickfix
        exec 'botright copen ' . ((a:size > 0) ? a:size : ' ')
        " Jump back to working window
        "exec ''.s:async_run_winnr.'wincmd w' " Not working :(
        call feedkeys("\<C-\>\<C-n>\<C-w>w", 'n')
    elseif l:mode == 0
        " Jump back to working window
        "exec ''.s:async_run_winnr.'wincmd w'
        call feedkeys("\<C-\>\<C-n>\<C-w>w", 'n')
        " Close quickfix
        cclose
        " Restore window state and discard window number
        if exists('w:quickfix_save')
           call winrestview(w:quickfix_save)
           unlet w:quickfix_save
        endif
        unlet s:async_run_winnr
    endif
endfunc
