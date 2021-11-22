call plug#begin('~/.vim/plugged')
    " Basic (also load in minilal.vim)
    Plug 'easymotion/vim-easymotion'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-surround'
    Plug 'machakann/vim-highlightedyank'
    Plug 'michaeljsmith/vim-indent-object'
    Plug 'wellle/targets.vim'
    Plug 'kana/vim-textobj-user'
    Plug 'kana/vim-textobj-entire'
    Plug 'terryma/vim-expand-region'
    Plug 'terryma/vim-multiple-cursors'
    Plug 'dbakker/vim-paragraph-motion'
    Plug 'tommcdo/vim-exchange'
    " Advance
    Plug 'bkad/CamelCaseMotion'
    Plug 'Lokaltog/vim-powerline' " vim 软件底部的命令行美化
    Plug 'yianwillis/vimcdoc' "中文帮助文档
    Plug 'scrooloose/nerdtree'  " 目录树
    "Plug 'Xuyuanp/nerdtree-git-plugin' " NERDTree git 增强
    Plug 'ctrlpvim/ctrlp.vim'  "跳转到声明处
    "Plug 'Valloric/YouCompleteMe'  " 自动补全，支持大部分语言
    Plug 'AndrewRadev/splitjoin.vim'  "拆分与合并结构体
    "Plug 'Visual-Mark'  "可视化mm标记，F2和Shift+F2往后和往前导航标记
    "Plug 'jistr/vim-nerdtree-tabs' " 打开多个tab时，共用一个NERDTree
    " Language
    "Plug 'tomlion/vim-solidity'
    "Plug 'fatih/vim-go
    "Plug 'klen/python-mode'
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => CamelCaseMotion
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <silent> <leader>w <Plug>CamelCaseMotion_w
map <silent> <leader>b <Plug>CamelCaseMotion_b
map <silent> <leader>e <Plug>CamelCaseMotion_e
sunmap <leader>w
sunmap <leader>b
sunmap <leader>e
sunmap <leader>ge
map <silent> <leader>ge <Plug>CamelCaseMotion_ge
omap <silent> i<leader>w <Plug>CamelCaseMotion_iw
xmap <silent> i<leader>w <Plug>CamelCaseMotion_iw

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => nerdtree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
nnoremap <leader>N :NERDTreeToggle<cr>

"autocmd VimEnter * NERDTree " 启动 vim 时自动打开 NEERDTree
" 自动打开 NEERDTree 后，焦点在文件区
"wincmd w
"autocmd VimEnter * wincmd w


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => nerdtree-git-plugin
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Symbol:
"       Modified  : "✹",
"       Staged    : "✚",
"       Untracked : "✭",
"       Renamed   : "➜",
"       Unmerged  : "═",
"       Deleted   : "✖",
"       Dirty     : "✗",
"       Clean     : "✔︎",
"       Ignored   : "☒",
"       Unknown   : "?"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => splitjoin
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" gS: split
" gJ: join


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-surround
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  cs"'  :  "Hello world!" -> 'Hello world!'
"  cs]}  :  [Hello] world! -> {Hello} world!
"  cs]{  :  [Hello] world! -> { Hello } world!
"  ysiw] :  Hello world!   -> [Hello] world!
"  ds"   :  "Hello world!" -> Hello world!
"  yss)  :  Hello world    -> (Hello world!)（整行包裹）


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-go
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" source $XDG_CONFIG_HOME/vim/plugin.d/vimgo.vim


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => CtrlP
" 帮助：<c-p> 唤醒 CtrlP 后，? 打开帮助
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:ctrlp_switch_buffer = 'et'
let g:ctrlp_working_path_mode = 'w'
" 启动 CtrlP 的快捷键和默认命令
let g:ctrlp_map = '<space>P'
let g:ctrlp_cmd = 'CtrlPBuffer'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
