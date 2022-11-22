" bd: 光标前后都是跳转范围
" overwin: 可以跨文件移动

" Move to start of word forward
" map <leader><leader>w <Plug>(easymotion-w)
" Move to start of word backward
" map <leader><leader>b <Plug>(easymotion-b)
" Move to end of word forward
map <leader><leader>e <Plug>(easymotion-e)
" Move to end of word backward
map <leader><leader>ge <Plug>(easymotion-ge)

" Move to word in current line
map <Leader><leader>l <Plug>(easymotion-lineforward)
map <Leader><leader>h <Plug>(easymotion-linebackward)

" Move to line
map <Leader><leader>j <Plug>(easymotion-j)
map <Leader><leader>k <Plug>(easymotion-k)
map <Leader><leader><leader>bdjk <Plug>(easymotion-bd-jk)
" nmap <Leader>L <Plug>(easymotion-overwin-line)

" Search by {char}
map <Leader><leader>f <Plug>(easymotion-f)
map <Leader><leader>F <Plug>(easymotion-F)
map <Leader><leader>t <Plug>(easymotion-t)
map <Leader><leader>T <Plug>(easymotion-T)
" <leader>/{char}{char}... to search n characters
map  <leader><leader>/ <Plug>(easymotion-sn)

" https://github.com/easymotion/vim-easymotion#n-character-search-motion
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

" These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
" different highlight method and have some other features )
" map  n <Plug>(easymotion-next)
" map  N <Plug>(easymotion-prev)

" doc: https://github.com/easymotion/vim-easymotion/blob/master/doc/easymotion.txt
" ref: https://github.com/easymotion/vim-easymotion/blob/master/plugin/EasyMotion.vim
let g:EasyMotion_space_jump_first = 1
let g:EasyMotion_startofline = 1 " set 0 if you want to kepp cursor at the same column after line move
let g:EasyMotion_smartcase = 1 " smart case sensitive (type `l` and match `l`&`L`)
let g:EasyMotion_use_smartsign_us = 1 " Smartsign (type `3` and match `3`&`#`)
let g:EasyMotion_keys = 'asdghklqwertyuiopzxcvbnmfj123'
