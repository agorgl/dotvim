fun! RunExtWin(cmd)
    " Given command quoted
    let givenCmd = "\"" . a:cmd . "\""
    " Current working directory in unix format
    let cwd = "\"" . substitute(getcwd(), "\\", "/", "g") . "\""
    " Guimacro param
    let guiMacro = join(["Print", givenCmd . ";", "Keys", "\"{Enter}\""], ' ')
    " ConEmuC dispatch command
    :exe "!start " . join(["ConEmuC.exe", "/GUIMACRO:" . expand($CONEMUHWND), guiMacro], ' ')
endfun

fun! RunExtSplitWin(cmd)
    let ecmd = "\"" . "call SetEscChar.cmd && " . a:cmd . "\""
    let guiMacro = join(["Shell", "new_console:s20VnI", ecmd], ' ')
    :exe "!start " . join(["ConEmuC.exe", "/GUIMACRO:" . expand($CONEMUHWND), guiMacro], ' ')
endfun

fun! RunExtLin(cmd)
    :exe ":Dispatch! " . a:cmd
endfun

fun! RunExtSplitLin(cmd)
    let execName = split(getcwd(),'/')[-1]
    let cmd1 = "bspc rule -a URxvt -o split_dir=south split_ratio=0.8"
    let cmd2 = "bspc rule -a " . execName . " -o state=floating"
    let cmd3 = "urxvt -e bash -c \"". a:cmd . "\""
    let fullcmd = join([cmd1, cmd2, cmd3], ' && ')
    :exe ":Dispatch! " . fullcmd
endfun

if has('win32')
:command -nargs=1 RunExt call RunExtWin(<args>)
:command -nargs=1 RunExtSplit call RunExtSplitWin(<args>)
elseif has('unix')
:command -nargs=1 RunExt call RunExtLin(<args>)
:command -nargs=1 RunExtSplit call RunExtSplitLin(<args>)
endif

:nnoremap <silent> <F5> :RunExtSplit g:build_cmd<CR>
:nnoremap <silent> <C-F5> :RunExtSplit g:clean_cmd<CR>
:nnoremap <silent> <F6> :RunExt g:build_cmd<CR>
:nnoremap <silent> <C-F6> :RunExt g:clean_cmd<CR>
