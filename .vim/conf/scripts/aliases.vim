fun! RunExt(cmd)
    " Given command quoted
    let givenCmd = "\"" . a:cmd . "\""
    " Current working directory in unix format
    let cwd = "\"" . substitute(getcwd(), "\\", "/", "g") . "\""
    " Guimacro param
    let guiMacro = join(["Print", givenCmd . ";", "Keys", "\"{Enter}\""], ' ')
    " ConEmuC dispatch command
    :exe "!start " . join(["ConEmuC.exe", "/GUIMACRO:" . expand($CONEMUHWND), guiMacro], ' ')
endfun

fun! RunExtSplit(cmd)
    let ecmd = "\"" . "call SetEscChar.cmd && " . a:cmd . "\""
    let guiMacro = join(["Shell", "new_console:s20VnI", ecmd], ' ')
    :exe "!start " . join(["ConEmuC.exe", "/GUIMACRO:" . expand($CONEMUHWND), guiMacro], ' ')
endfun

:command -nargs=1 RunExt call RunExt(<args>)
:command -nargs=1 RunExtSplit call RunExtSplit(<args>)

:nnoremap <silent> <F5> :RunExtSplit g:buildCmd<CR>
:nnoremap <silent> <C-F5> :RunExtSplit g:cleanCmd<CR>
:nnoremap <silent> <F6> :RunExt g:buildCmd<CR>
:nnoremap <silent> <C-F6> :RunExt g:cleanCmd<CR>
