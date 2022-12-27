" Reference:
"   https://github.com/tpope/vim-sensible: a universal set of defaults

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" language
let $LANG='en'
set encoding=utf-8
set langmenu=en
set helplang=cn
" line number
set number
" status in bottom right
set ruler " show cursor's location
set showcmd " show input command in normal mode
set showmode " show current mode
" indent
set tabstop=4  " <tab> witdh equals to 4 spaces
set expandtab  " replace <tab> with space
set shiftwidth=4 " < and > give 4-spaces indent
set softtabstop=4  " <delete> remove 4 space at ont time
set smarttab
set autoindent " auto indent new line
set smartindent " auto indent enhancement
"set cindent " C-style indent
" set switchbuf=useopen,usetab
" wrap
set wrap " enable wrap
set linebreak " won't cut word when wrapping
set textwidth=500 " wrap when characters exceeds this number
" search
set hlsearch " highlight search text
set incsearch " highlight first matched text immediately
set ignorecase smartcase " capital insensitive when typing lowercase, but not when typing uppercase
" enable syntax
syntax enable
set showmatch " highlight matched bracket
set matchtime=2 " response time of matching bracket (unit 1/10s)
" allow backspace over autoindent, line break, start of insert
set backspace=indent,eol,start
" zsh autocompletion style
set wildmode=full
set magic  " regular expression support
" turn off bell
set belloff=all
set novisualbell noerrorbells
set t_vb=
set tm=500
" enable mouse
set mouse=a
" timeout length to wait for mapped sequence
set timeoutlen=500
" auto read file if modified
set autoread
set hidden
" split window
set splitright " vertical split in right
set splitbelow " horizontal split in below
" word definition used by w, * and so on
set iskeyword=@,48-57,_,192-255,#,-  " add # -

" detech file type
filetype plugin indent on " :filetype to check if it opens. See :h filetype

" separate locations by ,
" e.g.: set directory=~/.cache/vim/swap,~/,/tmp
set directory=$XDG_CACHE_HOME/vim/swap
set backupdir=$XDG_CACHE_HOME/vim/backup
set viminfo+=n$XDG_CACHE_HOME/vim/viminfo
" " Turn persistent undo on
" " You can undo even when you close a buffer/VIM
set undodir=$XDG_CACHE_HOME/vim/undo
set undofile
set nobackup
set noswapfile
" set nowritebackup

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => UI
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" theme
"  colorscheme gruvbox
set background=dark

" enable the menu after typing <Tab> in command-line mode
set wildmenu
" files to ignore in wildmenu
set wildignore=*.o,*~,*.pyc,*/.DS_Store

" no relative number in insert mode, relative number in normal mode
" autocmd InsertEnter * :set norelativenumber number
" autocmd InsertLeave * :set relativenumber

" change cursor style according to mode
" https://github.com/mhinz/vim-galore#change-cursor-style-dependent-on-mode
if empty($TMUX)
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
    let &t_SR = "\<Esc>]50;CursorShape=2\x7"
else
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
    let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
endif
" enable 24-bit color
set termguicolors

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Abbreviations to avoid typo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
ab fro for
