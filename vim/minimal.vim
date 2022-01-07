" change cursor style according to mode
" https://github.com/mhinz/vim-galore#change-cursor-style-dependent-on-mode
if empty($TMUX)
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
    let &t_SR = "\<Esc>]50;CursorShape=2\x7"
else
    set term=screen-256color
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
    let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
endif

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
" tab indent
set tabstop=4  " <tab> witdh equals to 4 spaces
set expandtab  " replace <tab> with space
set shiftwidth=4 " < and > give 4-spaces indent
set softtabstop=4  " <delete> remove 4 space at ont time
set smarttab
" indent
set autoindent " auto indent new line
set smartindent " auto indent enhancement
"set cindent " C-style indent
" wrap
set wrap " enable wrap
set linebreak " won't cut word when wrapping
set textwidth=500 " wrap when characters exceeds this number
" search
set hlsearch " highlight search text
set incsearch " highlight first matched text immediately
set ignorecase smartcase " 关键词全小写字母时，忽略大小写；存在大写字母时，不忽略大小写；
" enable syntax
syntax enable
set showmatch " highlight matched bracket
set matchtime=2 " response time of matching bracket (unit 1/10s)
" configure backspace so it acts as it should act
set backspace=eol,start,indent
" detech file type
filetype plugin indent on " :filetype to check if opned. See :h vimrc-filetype
" zsh autocompletion style
set wildmode=full
set magic  " regular expression support
" turn off bell
set belloff=all
set novisualbell noerrorbells
set t_vb=
set tm=500

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Key mapping
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Esc
imap jj <Esc>
" redo
nnoremap U <C-r>

" move to wrapped line
nnoremap j gj
nnoremap k gk
set whichwrap+=<,>,h,l
" let &colorcolumn="120"  " show column when line exceeds 120 chars
"let &colorcolumn="80,".join(range(120,999),",")

" Leader Key
" Reference:
"       https://github.com/amix/vimrc
"       https://github.com/wklken/k-vim
"       https://github.com/liuchengxu/space-vim
"       https://spacevim.org/
"
" Help:
"   搜索对应 Section：/=> key
"   映射的符号见：:h notation
"   查看映射是否被占用：:map <leader>p
"   查看所有的命令：:command
" leader key
nnoremap <SPACE> <Nop>
let mapleader=" "

" cancel search highlight
nnoremap <silent> <leader><cr> :noh<cr>

" save and exit
nnoremap <leader>q :q<cr>
nnoremap <leader>qq :q!<cr>
nnoremap <leader>q1 :Bclose<cr>
nnoremap <leader>qw :wq<cr>
" write with root permission
command! W w !sudo tee % > /dev/null

" buffer
"open last alternative buffer
nnoremap <leader><Tab> <c-^>
"open last alternative buffer with a new split
nnoremap <leader>^ <C-W><C-^>

" tab
nnoremap <leader>i :tabprev<cr>
nnoremap <leader>o :tabnext<cr>
" Toggles between the active and last active tab "
" The first tab is always 1 "
let g:last_active_tab = 1
nnoremap <Leader>` :execute "tabnext ".g:last_active_tab<CR>
autocmd TabLeave * let g:last_active_tab = tabpagenr()
" tab navigation
noremap g1 1gt
noremap g2 2gt
noremap g3 3gt
noremap g4 4gt
noremap g5 5gt
noremap g6 6gt
noremap g7 7gt
noremap g8 8gt
noremap g9 9gt
noremap g0 :tablast<cr>

" split
set splitright " vertical split in right
set splitbelow " horizontal split in below
nnoremap <leader><bar> :vsplit<cr>
nnoremap <leader>_ :split<cr>
nnoremap <leader>j <C-W>j
nnoremap <leader>k <C-W>k
nnoremap <leader>h <C-W>h
nnoremap <leader>l <C-W>l
nnoremap <leader>J <C-W>J
nnoremap <leader>K <C-W>K
nnoremap <leader>H <C-W>H
nnoremap <leader>L <C-W>L

" select block
nnoremap <leader>v v`}
nnoremap <leader>V V`}
nnoremap <leader>N :NERDTreeToggle<cr>

" copy and paste
"set clipboard=unnamed " 使用系统剪切板
noremap 1y "+y
noremap 1Y "+y$
noremap 1d "+d
noremap 1D "+D
noremap 1p "+p
noremap 1P "+P
nnoremap Y y$
nnoremap gp <Esc>o<Esc>p<Esc>
nnoremap gP <Esc>O<Esc>p<Esc>
" 打开/关闭 paste mode
" paste mode 下，vim 去掉粘贴代码的缩进
nnoremap <leader>mp :setlocal paste!<cr>

" quick add empty line (can be used with number)
" https://github.com/mhinz/vim-galore#quickly-add-empty-lines
nnoremap <leader>[  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[
nnoremap <leader>]  :<c-u>put =repeat(nr2char(10), v:count1)<cr>

" scroll
nnoremap <C-e> 2<C-e>
nnoremap <C-y> 2<C-y>

" move to change location
nnoremap <silent> g; g;zz
nnoremap <silent> g, g,zz

" 调整缩进时防止失去选区
" https://github.com/mhinz/vim-galore#dont-lose-selection-when-shifting-sidewards
xnoremap <  <gv
xnoremap >  >gv

" 方便选择命令行历史和补全
" https://github.com/mhinz/vim-galore#saner-command-line-history
cnoremap <c-n> <down>
cnoremap <c-p> <up>

" 可视模式下，*/# 搜索可视内容（默认是搜索光标所在单词）
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>
" n / N 始终为向前 / 后搜索，不会因为 / 或 ? 的搜索方式而改变。
" https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
nnoremap <expr> n  'Nn'[v:searchforward]
nnoremap <expr> N  'nN'[v:searchforward]

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper function
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
