"set ignorecase -- doesn't work.
"Using the [] globbing construct, does work.  *sigh*
autocmd BufNewFile,BufRead *.[dD][bB][lL]     set filetype=dbl
autocmd BufNewFile,BufRead *.[tT][pP][lL]     set filetype=dbl
autocmd BufNewFile,BufRead *.[uU][tT][sSgGlL] set filetype=dbl
autocmd BufNewFile,BufRead *.[dD][eE][fF]     set filetype=dbl
