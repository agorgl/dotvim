""
"" vimtex options
""
let g:vimtex_latexmk_build_dir = 'build'
if has('win32')
let g:vimtex_view_general_viewer = 'SumatraPDF'
let g:vimtex_view_general_options = '-reuse-instance -forward-search @tex @line @pdf'
let g:vimtex_view_general_options_latexmk = '-reuse-instance'
elseif has('unix')
let g:vimtex_view_method = 'mupdf'
endif
