""-------------------------------------------------------------
"" Colors
""-------------------------------------------------------------
"
" Lightline utils
"
" Default lightline theme
let s:lightline_default_theme = 'wombat'

" List of available lightline colorschemes
fun! s:lightline_colorschemes()
    let colorscheme_files = globpath(&rtp,"autoload/lightline/colorscheme/*.vim", v:true, v:true)
    let colorscheme_names = map(colorscheme_files, "fnamemodify(v:val,':t:r')")
    return colorscheme_names
endfun

" List of matching lightline colorschemes for given name
fun! s:lightline_match_theme(name)
    let colorschemes = s:lightline_colorschemes()
    let matching = filter(colorschemes, 'v:val=~a:name')
    return len(matching) > 0 ?  matching[0] : ''
endfun

" Picks lightline colorscheme for given name
fun! s:lightline_pick_theme(name)
    let deflt = s:lightline_default_theme " Fallback
    let theme = s:lightline_match_theme(a:name)
    return !empty(theme) ? theme : deflt
endfun

" Sets lightline colorscheme
fun! s:lightline_set_theme(name)
    if exists('g:lightline')
        call extend(g:lightline, {'colorscheme': a:name})
    else
        let g:lightline = {'colorscheme': a:name}
    endif
endfun

"
" Colorscheme specific setups
"
fun! s:setup_molokai()
    let g:rehash256 = 1 " Molokai fix flag for 256 color terminals
    set termguicolors&  " Remove true color, makes whites too bright
    call s:lightline_set_theme('deus')
endfun

fun! s:setup_srcery()
    let g:srcery_hard_black_terminal_bg = 0
endfun

"
" Setup dispatcher
"
fun! s:setup_colorscheme_options(current_scheme)
    " Defaults for everything
    set termguicolors
    let matched = s:lightline_pick_theme(a:current_scheme)
    call s:lightline_set_theme(matched)

    " Apply specific setup function if exists
    let fname = 's:setup_' . a:current_scheme
    if exists('*'.fname)
        call function(fname)()
    endif
endfun

augroup colorschemechange
    autocmd!
    autocmd ColorSchemePre * call s:setup_colorscheme_options(expand('<amatch>'))
augroup END

exec 'colorscheme ' . get(g:, 'colors_name', 'default')
