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

" move to wrapped line
nnoremap j gj
nnoremap k gk
set whichwrap+=<,>,h,l
" let &colorcolumn="120"  " show column when line exceeds 120 chars
"let &colorcolumn="80,".join(range(120,999),",")

" redo
nnoremap U <C-r>
" Esc
imap jj <Esc>

" leader key
let mapleader = ","
let g:mapleader = ","
" cancel search highlight
map <silent> <leader><cr> :noh<cr>
" paste
nnoremap Y y$
nnoremap gp <Esc>o<Esc>p<Esc>
nnoremap gP <Esc>O<Esc>p<Esc>
" select block
nnoremap <leader>v v`}
nnoremap <leader>V V`}

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

try
    call plug#begin('~/.vim/plugged')
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
    call plug#end()
    runtime plugin.d/easymotion.vim
    " targets.vim
    let g:targets_aiAI = 'aIAi'
    autocmd User targets#mappings#user call targets#mappings#extend({
    \ 'a': {'argument': [{'o': '[({[]', 'c': '[]})]', 's': ','}]},
    \ 'b': {'pair': [{'o':'(', 'c':')'}]}
    \ })
    " expand-region
    map ak <Plug>(expand_region_expand)
    map aj <Plug>(expand_region_shrink)
    let g:expand_region_use_select_mode = 0
    " multiple-cursors
    let g:multi_cursor_select_all_key = 'g<C-n>'
catch
endtry

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
