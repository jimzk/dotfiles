" Automatic vim-plug installation
" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
let nvim_config_dir = $XDG_CONFIG_HOME . '/nvim'
if empty(glob(nvim_config_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.nvim_config_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(nvim_config_dir . '/plugged')
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
    Plug 'preservim/nerdtree'  " 目录树
    "Plug 'Xuyuanp/nerdtree-git-plugin' " NERDTree git 增强
    Plug 'ctrlpvim/ctrlp.vim'  "跳转到声明处
    "Plug 'Valloric/YouCompleteMe'  " 自动补全，支持大部分语言
    Plug 'AndrewRadev/splitjoin.vim'  "拆分与合并结构体
    "Plug 'Visual-Mark'  "可视化mm标记，F2和Shift+F2往后和往前导航标记
    "Plug 'jistr/vim-nerdtree-tabs' " 打开多个tab时，共用一个NERDTree
call plug#end()


" Note: configurations of particular plugins are put in nvim/plugin/ and will be loaded automatically.
