" Make .h files C filetype by default
augroup filetype_h
    autocmd!
    autocmd BufRead,BufNewFile *.h set filetype=c
augroup END

" Match background color with current colorscheme
if (has("autocmd") && !has("gui_running"))
    fun! MatchBackgroundColor()
        let s:curbg = synIDattr(synIDtrans(hlID('Normal')), 'bg', 'gui')
        call echoraw("\e]11;" . s:curbg . "\007")
    endfun

    fun! ResetBackgroundColor()
        call echoraw("\e]111;\007")
    endfun

    augroup colorchange
        autocmd!
        autocmd ColorScheme * call MatchBackgroundColor()
        autocmd VimLeave * call ResetBackgroundColor()
    augroup END

    call MatchBackgroundColor()
endif
