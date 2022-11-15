
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
colorscheme gruvbox
set background=dark

set cursorline
set cursorcolumn
" only show cursor line in normal mode
" https://github.com/mhinz/vim-galore#smarter-cursorline
autocmd InsertLeave,WinEnter * set cursorline cursorcolumn
autocmd InsertEnter,WinLeave * set nocursorline nocursorcolumn
set scrolloff=4 " minimal lines above and below the cursor

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
" => Key mapping
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" move to wrapped line
nnoremap j gj
nnoremap k gk
nnoremap 0 g0
nnoremap $ g$
nnoremap ^ g^
set whichwrap+=<,>,h,l
"  let &colorcolumn="120"  " show column when line exceeds 120 chars
" let &colorcolumn="80,".join(range(120,999),",")

" Keymap reference:
"     https://github.com/amix/vimrc
"     https://github.com/wklken/k-vim
"     https://github.com/liuchengxu/space-vim
"     https://spacevim.org/
"     https://github.com/LunarVim/nvim-basic-ide/blob/master/lua/user/keymaps.lua
" Help:
"     搜索对应 Section：/=> key
"     映射的符号见：:h notation
"     查看映射是否被占用：:map <leader>p
"     查看所有的命令：:command

" leader key
nnoremap , <Nop>
let mapleader=","

" Modes
"   normal_mode = "n",
"   insert_mode = "i",
"   visual_mode = "v",
"   visual_block_mode = "x",
"   term_mode = "t",
"   command_mode = "c",

imap jk <esc>
" no copy when paste in visual mode
vmap p "_dP
nnoremap U <c-r>  " redo
" Use <c-L> to clear the highlighting of :set hlsearch.
" https://github.com/tpope/vim-sensible/blob/8985da7669bbd73afce85ef0e4a3e1ce2e488595/plugin/sensible.vim#L33
if maparg('<c-l>', 'n') ==# ''
    nnoremap <silent> <c-L> :nohlsearch<c-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><c-L>
endif
" :W write with root permission
command! W w !sudo tee % > /dev/null
" buffer switch
"  nnoremap <leader><Tab> <c-^> " open last alternative buffer
"  nnoremap <leader>^ <c-W><c-^> "open last alternative buffer with a new split

" tab switch
"  nnoremap <leader>i :tabprev<cr>
"  nnoremap <leader>o :tabnext<cr>

" switch between the active and last active tab "
" The first tab is always 1 "
let g:last_active_tab = 1
nnoremap <silent> g<tab> :execute "tabnext ".g:last_active_tab<cr>
autocmd TabLeave * let g:last_active_tab = tabpagenr()

" move line up and down
" https://github.com/mhinz/vim-galore#quickly-move-current-line
nnoremap <silent> [e  :<c-u>execute 'move -1-'. v:count1<cr>
nnoremap <silent> ]e  :<c-u>execute 'move +'. v:count1<cr>

" copy and paste
"set clipboard=unnamed " 使用系统剪切板
noremap 1y "+y
noremap 1Y "+y$
noremap 1d "+d
noremap 1D "+D
noremap 1p "+p
noremap 1P "+P
nnoremap Y y$

" quick add empty line (can be used with number)
" https://github.com/mhinz/vim-galore#quickly-add-empty-lines
nnoremap <leader>[  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[
nnoremap <leader>]  :<c-u>put =repeat(nr2char(10), v:count1)<cr>

" scroll
nnoremap <c-e> 2<c-e>
nnoremap <c-y> 2<c-y>
" scroll in edit mode
inoremap <c-e> <c-x><c-e>
inoremap <c-e> <c-x><c-y>

" move to change location
nnoremap <silent> g; g;zz
nnoremap <silent> g, g,zz

" 调整缩进时防止失去选区
" https://github.com/mhinz/vim-galore#dont-lose-selection-when-shifting-sidewards
xnoremap <  <gv
xnoremap >  >gv

" n / N 始终为向前 / 后搜索，不会因为 / 或 ? 的搜索方式而改变。
" https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
nnoremap <expr> n  'Nn'[v:searchforward]
nnoremap <expr> N  'nN'[v:searchforward]

" show path of current file in command-line mode
" http://vim.wikia.com/wiki/Get_the_name_of_the_current_file
"  cnoremap $. <c-r>=expand('%:p:h')<cr>/
"  cnoremap t.<tab> tabedit <c-r>=expand("%:p:h")<cr>/
"  cnoremap e.<tab> e <c-r>=expand("%:p:h")<cr>/

" window layout
nmap <c-w><c--> <c-w>_  " maximize window height
nmap <c-w><c-\> <c-w>\|  " maximize window width
nmap <c-w><c-=> <c-w>=  " euqally size windows

" completion menu
" https://github.com/mhinz/vim-galore#saner-command-line-history
cnoremap <c-j> <up>
cnoremap <c-k> <down>  " complete and move to next selection menu
cnoremap <c-a> <home>
cnoremap <c-e> <end>
inoremap <c-a> <home>
inoremap <c-e> <end>
" move to word backward and forward
cnoremap <m-b> <s-left>
cnoremap <m-f> <s-right>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Abbreviations to avoid typo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
ab fro for
