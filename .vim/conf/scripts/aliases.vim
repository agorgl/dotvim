
fun! BuildExternalCommand(cmd)
    " Given command quoted
    let givenCmd = "\"" . a:cmd . "\""
    " Current working directory in unix format
    let cwd = "\"" . substitute(getcwd(), "\\", "/", "g") . "\""
    " Guimacro param
    "let guiMacro = "Shell" . " " . "\"new_console:sH\"" . " " . "\"\"" . " " . givenCmd . " " . cwd
    let guiMacro = "Print" . " " . givenCmd . ";" . "Keys" . " " . "\"{Enter}\""
    " ConEmuC dispatch command
    let fullCmd = "ConEmuC.exe" . " " . "/GUIMACRO:" . expand($CONEMUHWND) . " " . guiMacro
    return fullCmd
endfun

fun! RunExt(cmd)
    let extcmd = "!start " . BuildExternalCommand(a:cmd)
    :exe extcmd
endfun

:command -nargs=1 RunExt call RunExt(<args>)
:nnoremap <silent> <F5> :RunExt g:buildCmd<CR>
