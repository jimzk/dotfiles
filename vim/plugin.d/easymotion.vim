

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => easymotion
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" bd: 光标前后都是跳转范围
" overwin: 可以跨文件移动

" Move to start of word forward
map <leader>w <Plug>(easymotion-w)
imap <leader>w <Esc><leader>w
"map <Leader><leader>w <Plug>(easymotion-bd-w)
"nmap <Leader><leader>w <Plug>(easymotion-overwin-w)
"imap <leader>,w <Esc><leader><leader>w
" Move to start of word backward
map <leader>b <Plug>(easymotion-b)
imap <leader>b <Esc><leader>b
" Move to end of word forward
map <leader>e <Plug>(easymotion-e)
imap <leader>e <Esc><leader>e
" Move to end of word backward
map <leader>ge <Plug>(easymotion-ge)
imap <leader>ge <Esc><leader>ge

" Move to word in current line
map <Leader>l <Plug>(easymotion-lineforward)
imap <leader>l <Esc><leader>l
map <Leader>h <Plug>(easymotion-linebackward)
imap <leader>h <Esc><leader>h

" Move to line
map <Leader>j <Plug>(easymotion-j)
imap <leader>j <Esc><leader>j
map <Leader>k <Plug>(easymotion-k)
imap <leader>k <Esc><leader>k
map <Leader>L <Plug>(easymotion-bd-jk)
" nmap <Leader>L <Plug>(easymotion-overwin-line)
imap <leader>L <Esc><leader>L

" Search by {char}
map <Leader>f <Plug>(easymotion-f)
imap <leader>f <Esc><leader>f
map <Leader>F <Plug>(easymotion-F)
imap <leader>F <Esc><leader>F
map <Leader>t <Plug>(easymotion-t)
imap <leader>t <Esc><leader>t
map <Leader>T <Plug>(easymotion-T)
imap <leader>T <Esc><leader>F
" <leader>/{char}{char}... to search n characters
map  <leader>/ <Plug>(easymotion-sn)
imap <leader>/ <Esc><leader>/

let g:EasyMotion_startofline = 0 " keep cursor column when JK motion

" Smart case sensitive
" typing l matches l and L, but typing L only match L
let g:EasyMotion_smartcase = 1
