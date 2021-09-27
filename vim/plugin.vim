set rtp+=$XDG_CONFIG_HOME/vim/bundle/Vundle.vim

call vundle#begin() " 插件管理
Plugin 'VundleVim/Vundle.vim'

""" Recommend Plugins
Plugin 'Lokaltog/vim-powerline' " vim 软件底部的命令行美化
Plugin 'yianwillis/vimcdoc' "中文帮助文档
Plugin 'scrooloose/nerdtree'  " 目录树
"Plugin 'Xuyuanp/nerdtree-git-plugin' " NERDTree git 增强
Plugin 'ctrlpvim/ctrlp.vim'  "跳转到声明处
"Plugin 'Valloric/YouCompleteMe'  " 自动补全，支持大部分语言
Plugin 'AndrewRadev/splitjoin.vim'  "拆分与合并结构体
Plugin 'tpope/vim-surround'  "快速插入[{'等符号
Plugin 'easymotion/vim-easymotion'  " 移动增强
"Plugin 'Visual-Mark'  "可视化mm标记，F2和Shift+F2往后和往前导航标记
"Plugin 'jistr/vim-nerdtree-tabs' " 打开多个tab时，共用一个NERDTree

""" Development
"Plugin 'tomlion/vim-solidity'
"Plugin 'fatih/vim-go
"Plugin 'klen/python-mode'
call vundle#end()

runtime plugin.d/easymotion.vim

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
nmap <space>N :NERDTreeToggle<cr>
nmap <space>nb :NERDTreeFromBookmark<Space>
nmap <space>nf :NERDTreeFind<cr>

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
