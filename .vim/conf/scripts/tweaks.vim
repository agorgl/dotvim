"--------------------------------------------------------------------
" Filetype Mappings
"--------------------------------------------------------------------
" Make .h files C filetype by default
augroup filetype_h
    autocmd!
    autocmd BufRead,BufNewFile *.h set filetype=c
augroup END

" Detect and change yaml to kubernetes yaml filetype
function s:detect_kubernetes() abort
    if did_filetype() || (&ft != '' && &ft != 'yaml')
        return
    endif
    let l:first_line = getline(1)
    if l:first_line =~# '^\(kind\|apiVersion\): '
        set filetype=yaml.kubernetes
    endif
endfunction
autocmd BufNewFile,BufRead,BufEnter * call s:detect_kubernetes()

"--------------------------------------------------------------------
" Number/Sign columns Coloring
"--------------------------------------------------------------------
fun! s:match_column_colors()
    " Get sign column bg colors
    let guibg = synIDattr(synIDtrans(hlID('SignColumn')), 'bg', 'gui')
    if empty(l:guibg)
        let guibg = "NONE"
    endif
    let cterm = synIDattr(synIDtrans(hlID('SignColumn')), 'bg', 'cterm')
    if empty(l:cterm)
        let cterm = "NONE"
    endif

    " Set line number column bg colors to sign column bg colors
    exec 'hi LineNr' .
                \' guibg=' . l:guibg .
                \' ctermbg=' . l:cterm
endfun

call s:match_column_colors()

augroup column_colors
    autocmd!
    autocmd ColorScheme * call s:match_column_colors()
augroup END

"--------------------------------------------------------------------
" Background Coloring
"--------------------------------------------------------------------
fun! s:load_extra_colors()
    let colors = keys(v:colornames)
    let color_map = {}
    for name in colors
        let value = v:colornames[name]
        let r = str2nr(value[0:1], 16)
        let g = str2nr(value[2:3], 16)
        let b = str2nr(value[4:5], 16)
        let color_map[name] = [r, g, b]
    endfor
    return color_map
endfun

let s:extra_colors = s:load_extra_colors()

fun! s:translate_color(spec)
    let named_colors = {
      \   "black"        : [0x00, 0x00, 0x00],
      \   "blue"         : [0x00, 0x00, 0xFF],
      \   "brown"        : [0xA5, 0x2A, 0x2A],
      \   "cyan"         : [0x00, 0xFF, 0xFF],
      \   "darkblue"     : [0x00, 0x00, 0x8B],
      \   "darkcyan"     : [0x00, 0x8B, 0x8B],
      \   "darkgray"     : [0xA9, 0xA9, 0xA9],
      \   "darkgreen"    : [0x00, 0x64, 0x00],
      \   "darkgrey"     : [0xA9, 0xA9, 0xA9],
      \   "darkmagenta"  : [0x8B, 0x00, 0x8B],
      \   "darkred"      : [0x8B, 0x00, 0x00],
      \   "darkyellow"   : [0x8B, 0x8B, 0x00],
      \   "gray"         : [0xBE, 0xBE, 0xBE],
      \   "green"        : [0x00, 0xFF, 0x00],
      \   "grey"         : [0xBE, 0xBE, 0xBE],
      \   "grey40"       : [0x66, 0x66, 0x66],
      \   "grey50"       : [0x7F, 0x7F, 0x7F],
      \   "grey90"       : [0xE5, 0xE5, 0xE5],
      \   "lightblue"    : [0xAD, 0xD8, 0xE6],
      \   "lightcyan"    : [0xE0, 0xFF, 0xFF],
      \   "lightgray"    : [0xD3, 0xD3, 0xD3],
      \   "lightgreen"   : [0x90, 0xEE, 0x90],
      \   "lightgrey"    : [0xD3, 0xD3, 0xD3],
      \   "lightmagenta" : [0xFF, 0x8B, 0xFF],
      \   "lightred"     : [0xFF, 0x8B, 0x8B],
      \   "lightyellow"  : [0xFF, 0xFF, 0xE0],
      \   "magenta"      : [0xFF, 0x00, 0xFF],
      \   "red"          : [0xFF, 0x00, 0x00],
      \   "seagreen"     : [0x2E, 0x8B, 0x57],
      \   "white"        : [0xFF, 0xFF, 0xFF],
      \   "yellow"       : [0xFF, 0xFF, 0x00],
      \ }
    call extend(named_colors, s:extra_colors)

    if has_key(named_colors, tolower(a:spec))
        let color = named_colors[tolower(a:spec)]
        return printf('#%02X%02X%02X', color[0], color[1], color[2])
    elseif a:spec =~# '^\d\+$'
        return s:lookup_color_palette(a:spec)
    elseif a:spec =~# '^#[A-Fa-f0-9]\{6}$'
        return toupper(a:spec)
    endif

    return v:none
endfun

fun! s:lookup_color_palette(index)
    if a:index >= 0 && a:index < 16
        let ansi_colors = []
        " Normal intensity
        call add(ansi_colors, [   0,   0,   0 ]) " Black
        call add(ansi_colors, [ 224,   0,   0 ]) " Red
        call add(ansi_colors, [   0, 224,   0 ]) " Green
        call add(ansi_colors, [ 224, 224,   0 ]) " Yellow
        call add(ansi_colors, [   0,   0, 224 ]) " Blue
        call add(ansi_colors, [ 224,   0, 224 ]) " Magenta
        call add(ansi_colors, [   0, 224, 224 ]) " Cyan
        call add(ansi_colors, [ 224, 224, 224 ]) " White == Light Grey
        " High intensity
        call add(ansi_colors, [ 128, 128, 128 ]) " Black
        call add(ansi_colors, [ 255,  64,  64 ]) " Red
        call add(ansi_colors, [  64, 255,  64 ]) " Green
        call add(ansi_colors, [ 255, 255,  64 ]) " Yellow
        call add(ansi_colors, [  64,  64, 255 ]) " Blue
        call add(ansi_colors, [ 255,  64, 255 ]) " Magenta
        call add(ansi_colors, [  64, 255, 255 ]) " Cyan
        call add(ansi_colors, [ 255, 255, 255 ]) " White for real
        let color = ansi_colors[a:index]
    elseif a:index >= 16 && a:index < 232
        " 216 color cube
        let idx = a:index - 16
        let ramp6 = [ 0x00, 0x5F, 0x87, 0xAF, 0xD7, 0xFF ]
        let color = [ ramp6[idx / 36 % 6],
                    \ ramp6[idx / 6  % 6],
                    \ ramp6[idx      % 6], ]
    elseif a:index >= 232 && a:index < 256
        " 24 greyscales
        let idx = a:index - 232
        " Use 0x81 instead of 0x80 to be able to distinguish from ansi black
        let ramp24 = [ 0x08, 0x12, 0x1C, 0x26, 0x30, 0x3A,
                     \ 0x44, 0x4E, 0x58, 0x62, 0x6C, 0x76,
                     \ 0x81, 0x8A, 0x94, 0x9E, 0xA8, 0xB2,
                     \ 0xBC, 0xC6, 0xD0, 0xDA, 0xE4, 0xEE, ]
        let color = [ ramp24[idx], ramp24[idx], ramp24[idx] ]
    endif

    return !empty(color)
      \ ? printf('#%02X%02X%02X', color[0], color[1], color[2])
      \ : v:none
endfun

" Match background color with current colorscheme
if (has("autocmd") && !has("gui_running"))
    fun! s:match_background_color()
        let colrt = &termguicolors ? 'gui' : 'cterm'
        let curbg = synIDattr(synIDtrans(hlID('Normal')), 'bg', colrt)
        let trans = s:translate_color(curbg)
        if !empty(trans)
            call echoraw("\e]11;" . trans . "\007")
        endif
    endfun

    fun! s:reset_background_color()
        call echoraw("\e]111;\007")
    endfun

    augroup colorchange
        autocmd!
        autocmd ColorScheme * call s:match_background_color()
        autocmd VimLeave * call s:reset_background_color()
    augroup END

    call s:match_background_color()
endif
