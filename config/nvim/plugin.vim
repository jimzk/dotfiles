" Automatic vim-plug installation
" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
let nvim_config_dir = $XDG_CONFIG_HOME . '/nvim'
if empty(glob(nvim_config_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.nvim_config_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(nvim_config_dir . '/plugged')
    Plug 'folke/which-key.nvim'  " Display popup of keymap hint (together with keybinding)
                                 " :checkhealth which_key checks conflicting keymaps.
                                 " :WhichKey shows all mapping, :WhichKey <leader>g shows all <leader>g mapping
                                 " In popup, <backspace> go up one level, <c-d> and <c-u> scroll page.
    " ----- Fuzzy search
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }  " fuzzy search
    Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }  " support fzf-like syntax in searching
    " research
    "  nvim-telescope/telescope-frecency.nvim
    "  Plug 'nvim-telescope/telescope-file-browser'
    "  Plug 'nvim-telescope/telescope-project.nvim'
    "  Plug 'nvim-telescope/telescope-github.nvim'  -- manage github
    "  Plug 'pwntester/octo.nvim'  -- manage github

    "  https://github.com/AckslD/nvim-neoclip.lua

    "  Learn to write extensions
    "  Plug 'LinArcX/telescope-scriptnames.nvim'
    "  Plug "LinArcX/telescope-env.nvim"


    "  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }  " support fzf-like syntax in searching
    "  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    "  Plug 'junegunn/fzf.vim'  " :Fzf<Tab> shows commands

    " ----- Navigation
    Plug 'easymotion/vim-easymotion'
    Plug 'preservim/nerdtree'  " <leader>n toggle file tree
    Plug 'mbbill/undotree'  " F5 toggles undo tree
    Plug 'chentoast/marks.nvim'  " Visualiaze marks

    " ----- Edit
    "  Plug 'terryma/vim-multiple-cursors'  " CTRL-n adds multiple cursors and edit
    Plug 'mg979/vim-visual-multi', {'branch': 'master'}  " CTRL-n adds multiple cursors and edit
    Plug 'farmergreg/vim-lastplace'  " Open file at last edit position
    Plug 'tpope/vim-commentary'  " gcc toggles comment
    "  Plug 'numToStr/Comment.nvim'  " leave it as uncomment is supported
    Plug 'tommcdo/vim-exchange'  " First cx{motion} defines first content, and second cx{motion} performs exchange
                                 " cxx selects line, X selects visual mode, cxc clears all
    Plug 'AndrewRadev/splitjoin.vim'  " gJ joins lines and keep leading spaces. As a contract J removes leading spaces.
                                      " gS splits line by language.
    Plug 'tpope/vim-surround'  " Operate on surroundings (parentheses, brackets, quotes, XML tags)
                               " cs"'  :  "Hello world!" -> 'Hello world!'
                               " cs]}  :  [Hello] world! -> {Hello} world!
                               " cs]{  :  [Hello] world! -> { Hello } world!
                               " ysiw] :  Hello world!   -> [Hello] world!
                               " ds"   :  "Hello world!" -> Hello world!
                               " yss)  :  Hello world    -> (Hello world!)（wrap all line)

    " ------ Motion
    Plug 'bkad/CamelCaseMotion'  " <leader> + w/b/e/ge select camel case word
    Plug 'michaeljsmith/vim-indent-object'  " ai, ii, aI, iI select content in the same indent
    Plug 'wellle/targets.vim'  " Select content inside bracket, quote, separator (, . ; etc.), argument and tags
                               " Work like di' and support i a I a
                               " most frequently used: ib(bracket), iq(quote), ia(argument)
                               " inx/ilx select next/last objects, x can be any char
    Plug 'kana/vim-textobj-user'  " Dependency of vim-textobj-user
    Plug 'kana/vim-textobj-entire'  " ae, ie select entire content
    Plug 'terryma/vim-expand-region' " + expands visual selection, _ shrinks it.
    Plug 'dbakker/vim-paragraph-motion'  " Include blank lines when using { and } to select paragraph
    Plug 'andymass/vim-matchup'  " Replacement for builtin % enhancement plugin matchit.
                                 " %, [%, ]%, i%, a%. See :h matchup-usage.

    " ----- Git
    Plug 'tpope/vim-fugitive'  " Integrate git.
                               " :Git opens summary window, and g? shows help.
                               " :Gsplit HEAD~3:% load current file of HEAD~3
    Plug 'lewis6991/gitsigns.nvim'  " Git changes visualization. :Gitsigns toggle<Tab> to toggle signs.
                                    " :Gitsigns diffthis diffs buffer
                                    " There are also useful operations for hunk.

    " ----- Development
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " Syntax highlight
                                                                 " :TSInstall <language> to install parser
                                                                 " :TSUpdate to update parser
    " ----- LSP

    " ----- Appearance
    Plug 'machakann/vim-highlightedyank'
    Plug 'nvim-lualine/lualine.nvim'  " statusline
    Plug 'nvim-tree/nvim-web-devicons'  " icon support for lualine
    Plug 'ryanoasis/vim-devicons'  " icon support for nerdtree
    "  https://github.com/kdheepak/tabline.nvim
    "  https://github.com/akinsho/bufferline.nvim
    " Notification
    "  Plug 'folke/noice.nvim'  " UI for messages, cmdline and popupmenu. depend on nvim-notify
    "  Plug 'MunifTanjim/nui.nvim'  " better rendering for noice.nvim

    " ----- Integrations
    Plug 'rcarriga/nvim-notify'  " notification manager

    " ----- MISC
    Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }  " :MarkdownPreviewToggle toggles preview

    "  Plug 'nvim-tree/nvim-tree.lua'
    "  Plug 'vim-ctrlspace/vim-ctrlspace'  " manage tabs, buffers, files, workspace, bookmarks
    "  Plug 'ctrlpvim/ctrlp.vim'
    "  Plug 'jiangmiao/auto-pairs'
    "  Plug 'tpope/vim-unimpaired'
    "  Plug "yazgoo/yank-history"
    "  Plug "tpope/vim-vinegar"
call plug#end()

" Note: configurations of particular plugins in nvim/plugin/ will be loaded automatically.
