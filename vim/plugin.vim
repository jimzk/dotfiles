" Automatic vim-plug installation
" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
let data_dir = $XDG_CONFIG_HOME . '/vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin($XDG_CONFIG_HOME . '/vim/plugged')
    " Basic
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
    Plug 'vim-airline/vim-airline'
    Plug 'yianwillis/vimcdoc' "中文帮助文档
    Plug 'preservim/nerdtree'  " 目录树
    "Plug 'Xuyuanp/nerdtree-git-plugin' " NERDTree git 增强
    Plug 'ctrlpvim/ctrlp.vim'  "跳转到声明处
    "Plug 'Valloric/YouCompleteMe'  " 自动补全，支持大部分语言
    Plug 'AndrewRadev/splitjoin.vim'  "拆分与合并结构体
    "Plug 'Visual-Mark'  "可视化mm标记，F2和Shift+F2往后和往前导航标记
    "Plug 'jistr/vim-nerdtree-tabs' " 打开多个tab时，共用一个NERDTree
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Customization
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

runtime plugin.d/easymotion.vim
runtime plugin.d/CamelCaseMotion.vim
runtime plugin.d/targets.vim
runtime plugin.d/expand-region.vim
runtime plugin.d/multiple-cursors.vim

runtime plugin.d/nerdtree.vim
runtime plugin.d/ctrlP.vim

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
