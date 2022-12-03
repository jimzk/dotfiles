" function to set command alias in command-line mode
" https://stackoverflow.com/a/7515418/10134408
fun! SetupCommandAlias(from, to)
    exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfun

" delete trailling blank lines when saving.
autocmd BufWritePre * :call CleanExtraSpaces()
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

" auto reload VIMRC if change *.vim in vim
" autocmd BufWritePost *.vim,*.vimrc source $MYVIMRC | redraw | execute "echo 'reload configuration!'"
