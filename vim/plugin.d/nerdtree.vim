" Note:
"       ?     ：显示/关闭帮助
"       o/go  ：在缓存区里打开文件；O 递归地打开文件
"       t/T   ：在标签里打开文件
"       ---------根目录----------
"       cd    ：设置 CWD 为所选文件目录
"       CD    ：打开 CWD 目录
"       C     ：打开所选文件的目录
"       u     ：回到上级目录
"       U     ：回到上级目录，但保持打开当前目录
"       ---------光标跳转---------
"       p/P   ：跳转到父/根目录
"       J/K   ：跳转到第一/最后的文件
"       <C-j>/<C-k> ：跳转到下/上一个同级文件
"       ----------其他------------
"       m     ：对文件进行操作
"       :Bookmark ：新建书签
"

let g:NERDTreeWinPos = "left"
let NERDTreeShowBookmarks=1 " 默认显示书签
let NERDTreeShowHidden=0  " 默认不显示隐藏文件
let NERDTreeQuitOnOpen=0  " 打开文件后：1 关闭 NERDTRee；2 不关闭 NERDTRee
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let g:NERDTreeWinSize=35
nnoremap <leader>n :NERDTreeToggle<cr>

"autocmd VimEnter * NERDTree " 启动 vim 时自动打开 NEERDTree
" 自动打开 NEERDTree 后，焦点在文件区
"wincmd w
"autocmd VimEnter * wincmd w
