"set shellcmdflag=-ci

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Init
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 设置命令行模式的别名
" https://stackoverflow.com/a/7515418/10134408
fun! SetupCommandAlias(from, to)
    exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfun

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Feature
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible " 关闭 vi 兼容模式
set mouse-=a " 不启用鼠标
set history=500 " history 存储容量
"set shell=zsh\ -i " 在 iTerm2 的 vi 下用 :NERDTreeToggle 时起冲突

" Properly disable sound on errors on MacVim
if has("gui_macvim")
    autocmd GUIEnter * set vb t_vb=
endif

" 启动的时候不显示援助乌干达儿童的提示
set shortmess=atI

" 取消备份
set nobackup
" 不生成交换文件
" http://blog.csdn.net/pwiling/article/details/51830781
set noswapfile
set nowb

" 执行宏时不重绘界面（提高性能）
set lazyredraw

" wildmenu：命令模式里按 Tab 后显示的候选项菜单
set wildmenu
" wildmenu 里忽略显示的文件
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => UI
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Highlight line and column
set cursorline
set cursorcolumn
" Minimal lines above and below the cursor
set scrolloff=4
" 禁止光标闪烁
"set gcr=a:block-blinkon0

" 显示相对行号: 行号变成相对，可以用 nj/nk 进行跳转
"set relativenumber number
"au FocusLost * :set norelativenumber number
"au FocusGained * :set relativenumber
" 插入模式下用绝对行号, 普通模式下用相对
"autocmd InsertEnter * :set norelativenumber number
"autocmd InsertLeave * :set relativenumber
function! NumberToggle()
    if(&relativenumber == 1)
        set norelativenumber number
    else
        set relativenumber
    endif
endfunc
"nnoremap <C-n> :call NumberToggle()<cr>

" 只让高亮行出现在当前窗口，且在插入模式中关闭这个效果
" https://github.com/mhinz/vim-galore#smarter-cursorline
autocmd InsertLeave,WinEnter * set cursorline
autocmd InsertEnter,WinLeave * set nocursorline

" gui 界面
if has("gui_running")
    set guioptions-=l " 无左滚动条
    set guioptions-=r " 无右滚动条
    set guioptions-=L " 垂直分割窗口无左滚动条
    set guioptions-=R " 垂直分割窗口无右滚动条

    set guioptions-=T " 无工具栏
    set guioptions-=e " 无默认标签文本
    "set guitablabel=%M\ %t " 显示自定义标签文本
endif

" status line
set laststatus=2 "显示下方的状态栏
let g:Powerline_symbols = 'fancy'
let g:Powerline_colorscheme='solarized256'
" 状态栏格式化
" http://www.xefan.com/archives/83820.html
"set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c\ \ %p%%

" theme
colorscheme gruvbox
set background=dark
set t_Co=256 " 色彩范围
highlight Visual  guifg=White guibg=LightBlue gui=none  " 选区颜色

" Use Unix as the standard file type
set ffs=unix,dos,mac

" 测试字体效果：:set guifont=* 和 :put=&guifont测试字体效果
set guifont=Monaco:h14

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 将 meta 设成 Alt 键，只在 GUIVim 下有效。
if has("gui_macvim")
    set macmeta
endif
" Alt-j/k 上下移动当前行
" 若想使用 ⌘ - j/k ，则设置成<D-j/k>
"nmap <M-j> mz:m+<cr>`z
"nmap <M-k> mz:m-2<cr>`z
"vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
"vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z
" 上下移动行，可配合数字
" https://github.com/mhinz/vim-galore#quickly-move-current-line
nnoremap [e  :<c-u>execute 'move -1-'. v:count1<cr>
nnoremap ]e  :<c-u>execute 'move +'. v:count1<cr>

"noremap <C-[> <C-t>" 回退

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Search
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 保持搜索结果在屏幕中间
"nnoremap <silent> n nzzzv
"nnoremap <silent> N Nzzzv

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Buffer
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 关闭当前缓冲区。如果当前缓存区在多个 tab/window 里，则会一起关闭
"map <leader>bc :Bclose<cr>:tabclose<cr>gT
"call SetupCommandAlias("bclose", ":Bclose<cr>:tabclose<cr>gT")
command! Bclose :Bclose | tabclose | tabnext
call SetupCommandAlias("bc", "Bclose")

" 关闭所有标签里的所有缓冲区
"map <leader>bca :bufdo bd<cr>
"command! BcloseA :bufdo bd
call SetupCommandAlias("bca", "bufdo bd<cr>")

" 切换到缓冲区的行为
set switchbuf=useopen,usetab

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Tabs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call SetupCommandAlias("tn", "tabnew")
call SetupCommandAlias("te", "tabedit")
call SetupCommandAlias("tc", "tabclose")
call SetupCommandAlias("to", "tabonly")
call SetupCommandAlias("tm", "tabmove")

" 切换 tab
if has("gui_running")
    " 在终端vim里不起作用
    map <C-tab> :tabnext<cr>
    map <C-S-tab> :tabprev<cr>
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Auto read file if modified
set autoread
" 文件未保存时，也不会禁止切换到其他文件
set hidden

" Delete trailling blank lines when saving.
if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif

" 打开文件后，定位到上次编辑处
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" 防止切换 buffer 时，光标在屏幕的绝对位置改变
" https://stackoverflow.com/a/18244751/10134408
if v:version >= 700
    au BufLeave * if !&diff | let b:winview = winsaveview() | endif
    au BufEnter * if exists('b:winview') && !&diff | call winrestview(b:winview) | unlet! b:winview | endif
endif

" 修改*$VIM/*和.vimrc配置文件后自动加载
autocmd! bufwritepost *.vim,.vimrc source ~/.vimrc | redraw | execute "echom '.vimrc is sourced!'"
call SetupCommandAlias("vrc", "e $VIM/vim_runtime/vimrcs/basic.vim")

" 外部程序打开文件
nnoremap <silent> \ :!open <C-R>%<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" quickfix：上/下一个错误
"nnoremap <C-M> :cp<cr>
"nnoremap <C-N> :cn<cr>
" 关闭 quickfix
"nnoremap <Leader>a :cclose<CR>

" Switch CWD to the directory of the open buffer
" map <leader>cd :cd %:p:h<cr>:pwd<cr>
"set autochdir " 自动将 CWD 切换为当前缓冲区所在目录

" 重绘当前屏幕
" https://github.com/mhinz/vim-galore#saner-ctrl-l
" nnoremap <leader>l :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>

" Automatic commands
if has("autocmd")
    " Enable file type detection
    filetype on
    " Treat .json files as .js
    autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
    " Treat .md files as Markdown
    autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 删除行尾空格
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Don't close window, when deleting a buffer
" -bar 表示命令后面可以跟 |
command! -bar Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction
