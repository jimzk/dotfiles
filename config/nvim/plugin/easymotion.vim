" https://github.com/easymotion/vim-easymotion
"
" bd: bidirectional motions, support both forward and backward.
" overwin: over windows

" Move to word
map <leader><leader>w <Plug>(easymotion-w)
map <leader><leader>b <Plug>(easymotion-b)
map <leader><leader>e <Plug>(easymotion-e)
map <leader><leader>ge <Plug>(easymotion-ge)

" Move to word in current line
map <Leader><leader>l <Plug>(easymotion-lineforward)
map <Leader><leader>h <Plug>(easymotion-linebackward)

" Move to line
map <Leader><leader>j <Plug>(easymotion-j)
map <Leader><leader>k <Plug>(easymotion-k)
map <Leader><leader><space> <Plug>(easymotion-bd-jk)
map <Leader><leader><leader>bdjk <Plug>(easymotion-bd-jk)
" nmap <Leader>L <Plug>(easymotion-overwin-line)

" Search (followed by {char})
map <Leader><leader>f <Plug>(easymotion-f)
map <Leader><leader>F <Plug>(easymotion-F)
map <Leader><leader>t <Plug>(easymotion-t)
map <Leader><leader>T <Plug>(easymotion-T)
"  map <leader><leader>/ <Plug>(easymotion-sn)

" default configs: https://github.com/easymotion/vim-easymotion/blob/master/plugin/EasyMotion.vim
let g:EasyMotion_space_jump_first = 1
let g:EasyMotion_startofline = 1 " set 0 if you want to kepp cursor at the same column after line move
let g:EasyMotion_smartcase = 1 " smart case sensitive (type `l` and match `l`&`L`)
let g:EasyMotion_use_smartsign_us = 1 " Smartsign (type `3` and match `3`&`#`)
let g:EasyMotion_keys = 'asdghklqwertyuiopzxcvbnmfj;'
