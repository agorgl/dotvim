" Overrides for transparent terminals
fun! EnableTransparentBg()
    if &t_Co > 255
        " Visual tweaks
        hi Identifier      cterm=bold
        hi MatchParen      ctermfg=229

        " Turn off all background colors
        if exists("g:nobg256") && g:nobg256 == 1
            hi Normal          ctermbg=none
            hi Todo            ctermbg=none
            hi LineNr          ctermbg=none

            hi Cursor          ctermbg=none
            hi CursorLine      ctermbg=none

            hi DiffAdd         ctermbg=none
            hi DiffChange      ctermbg=none
            hi DiffDelete      ctermbg=none
            hi DiffText        ctermbg=none

            hi Error           ctermbg=none
            hi ErrorMsg        ctermbg=none
            hi WarningMsg      ctermbg=none

            hi FoldColumn      ctermbg=none
            hi Folded          ctermbg=none

            hi Ignore          ctermbg=none

            hi Search          ctermbg=none
            hi IncSearch       ctermbg=none
            hi MatchParen      ctermbg=none

            hi SpellBad        ctermbg=none
            hi SpellCap        ctermbg=none
            hi SpellLocal      ctermbg=none
            hi SpellRare       ctermbg=none

            hi VertSplit       ctermbg=none

            " Leave these, changing them is silly and weird
            "hi StatusLine      ctermbg=none
            "hi StatusLineNC    ctermbg=none

            " Keep selection hilighting
            "hi Visual          ctermbg=none
            "hi VisualNOS       ctermbg=none

            hi WildMenu        ctermbg=none

            hi CursorColumn    ctermbg=none
            hi ColorColumn     ctermbg=none

            hi Pmenu           ctermbg=none
            hi PmenuSel        ctermbg=none
            hi PmenuSbar       ctermbg=none
            hi SignColumn      ctermbg=none
        endif
    endif
endfun

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
