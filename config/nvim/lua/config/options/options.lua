-- This file is automatically loaded by plugins.config
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.autoread = true
opt.autowrite = true -- enable auto write
opt.clipboard = "unnamedplus" -- sync with system clipboard
opt.cmdheight = 1
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 3 -- Hide * markup for bold and italic
-- opt.confirm = true -- confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line

opt.hlsearch = true -- Highlight search text
opt.incsearch = false -- Not jump to the first match immediately
opt.wrap = false -- Disable line wrap
opt.scrolloff = 4 -- Lines of context
opt.sidescrolloff = 8 -- Columns of context
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.number = true -- Print line number
opt.relativenumber = true -- Relative line numbers

opt.tabstop = 4 -- Number of spaces tabs count for
opt.shiftwidth = 4 -- Size of an indent
opt.shiftround = true -- Round indent
opt.expandtab = true -- Use spaces instead of tabs
opt.smartindent = true -- Insert indents automatically

opt.showmode = false -- dont show mode since we have a statusline
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.guifont = "FiraCode Nerd Font:h11"

opt.ignorecase = true -- Ignore case
opt.smartcase = true -- Don't ignore case with capitals
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.hidden = true -- Enable modified buffers in background
opt.inccommand = "nosplit" -- preview incremental substitute
opt.laststatus = 0
opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "a" -- enable mouse mode
opt.jumpoptions = "stack" -- Make jumplist behave like web browser back / forward
opt.sessionoptions =
  { "buffers", "curdir", "folds", "help", "tabpages", "winpos", "winsize", "terminal", "localoptions" }
opt.spelllang = { "en" }
opt.termguicolors = true -- True color support
opt.timeoutlen = 300
opt.updatetime = 200 -- save swap file and trigger CursorHold
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- minimum window width
opt.linebreak = true -- won't cut word when wrapping

opt.undofile = true
opt.undolevels = 10000
-- opt.swapfile = false

opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.splitkeep = "screen"

opt.magic = true -- Support regex in cmdline
opt.wildmenu = true -- Enable Menu after <Tab> in cmdline
opt.wildignore = "*.o,*~,*.pyc,*/.DS_Store" -- Files ignored in wildmenu

opt.shortmess = "filnxtToOFWIcC"
-- Noice.nvim compatibility
-- https://github.com/folke/noice.nvim/wiki/A-Guide-to-Messages#handling-hit-enter-messages
-- opt.shortmess = "filnxtToOFWIcCs" --

-- Text
opt.joinspaces = false -- No double spaces with join after a dot
opt.whichwrap:append("[,],<,>,h,l") -- Allow arrow and hl to move cross lines

-- fix markdown indentation settings
vim.g.markdown_recommended_style = 0
