-- This file is automatically loaded by plugins.config
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.autoread = true
opt.autowrite = true -- enable auto write
opt.clipboard = "unnamedplus" -- sync with system clipboard
opt.cmdheight = 1
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 0 -- Hide * markup for bold and italic
-- opt.confirm = true -- confirm to save changes before exiting modified buffer
opt.cursorline = false -- highlighting of the current line

opt.hlsearch = true -- Highlight search text
opt.incsearch = true -- Not jump to the first match immediately
opt.wrap = true -- Line wrap
opt.scrolloff = 4 -- Lines of context
opt.sidescrolloff = 10 -- Columns of context

opt.number = true -- Print line number
-- opt.relativenumber = true -- Relative line numbers
opt.signcolumn = "yes:1"
opt.numberwidth = 3
-- NOTE: number is not right aligned.
opt.statuscolumn = "%=%l%= %s"

opt.tabstop = 4 -- Number of spaces tabs count for
opt.shiftwidth = 4 -- Size of an indent
opt.shiftround = true -- Round indent
opt.expandtab = true -- Use spaces instead of tabs
opt.smartindent = true -- Insert indents automatically

opt.showmode = false -- dont show mode since we have a statusline
opt.guifont = "FiraCode Nerd Font:h11"

opt.ignorecase     = true -- Ignore case
opt.smartcase      = true -- Don't ignore case with capitals
opt.formatoptions  = "jcroqlnt" -- tcqj
opt.virtualedit    = "block" -- Allow going past the end of line in visual block mode
opt.grepformat     = "%f:%l:%c:%m"
opt.grepprg        = "rg --vimgrep"
opt.hidden         = true -- Enable modified buffers in background
opt.inccommand     = "nosplit" -- preview incremental substitute
opt.laststatus     = 3
opt.mouse          = "a" -- enable mouse for all mode
-- https://www.reddit.com/r/neovim/comments/11dmaed/keep_buffer_view_when_you_return_to_file/
-- https://www.reddit.com/r/neovim/comments/16nead7/comment/k1e1nj5/
opt.jumpoptions    = "stack,view" -- Make jumplist behave like web browser back / forward
-- https://www.reddit.com/r/neovim/comments/11bppvy/neovim_using_the_spellchecker/
opt.spelllang      = { "en_us" }
opt.spell          = false
opt.termguicolors  = true -- True color support
opt.timeoutlen     = 300
opt.updatetime     = 200 -- save swap file and trigger CursorHold
opt.wildmode       = "longest:full,full" -- Command-line completion mode
opt.linebreak      = true -- won't cut word when wrapping
opt.sessionoptions =
  { "blank", "buffers", "curdir", "folds", "help", "tabpages", "winpos", "winsize", "terminal", "localoptions" }
opt.winminwidth    = 1 -- minimum window width
opt.winminheight   = 0 -- minimum window height

opt.undofile = true
opt.undolevels = 10000
opt.swapfile = false
opt.backup = false -- Don't backup file while overwriting file
opt.writebackup = false

opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.splitkeep = "screen"

-- UI
opt.pumblend  = 5 -- Make builtin completion menus slightly transparent
opt.pumheight = 12 -- Make popup menu smaller
opt.winblend  = 0 -- Make floating windows slightly transparent. Shoule be zero or treesitter-context will be affected
opt.list      = true -- Show some invisible characters (tabs...
---@diagnostic disable-next-line: assign-type-mismatch
opt.listchars = "tab:> ,trail:·,nbsp:+,extends:…,precedes:…" -- Define which helper symbols to show

-- Window border
-- From: https://github.com/echasnovski/mini.basics/blob/main/lua/mini/basics.lua#L477
opt.fillchars = [[eob: ,fold: ,foldopen: ,foldsep: ,foldclose:]]

local win_borders_fillchars = {
  bold   = { vert = "vert:┃", rest = ",horiz:━,horizdown:┳,horizup:┻,,verthoriz:╋,vertleft:┫,vertright:┣" },
  dot    = { vert = "vert:·", rest = ",horiz:·,horizdown:·,horizup:·,,verthoriz:·,vertleft:·,vertright:·" },
  double = { vert = "vert:║", rest = ",horiz:═,horizdown:╦,horizup:╩,,verthoriz:╬,vertleft:╣,vertright:╠" },
  single = { vert = "vert:│", rest = ",horiz:─,horizdown:┬,horizup:┴,,verthoriz:┼,vertleft:┤,vertright:├" },
  solid  = { vert = "vert: ", rest = ",horiz: ,horizdown: ,horizup: ,,verthoriz: ,vertleft: ,vertright: " },
}
local fillchars = win_borders_fillchars["single"]
local chars = fillchars.vert .. fillchars.rest
opt.fillchars:append(chars)

opt.magic      = true -- Support regex in cmdline
opt.wildmenu   = true -- Enable Menu after <Tab> in cmdline
opt.wildignore = "*.o,*~,*.pyc,*/.DS_Store" -- Files ignored in wildmenu
opt.shortmess  = "filnxtToOFWIcC"
-- Noice.nvim compatibility
-- https://github.com/folke/noice.nvim/wiki/A-Guide-to-Messages#handling-hit-enter-messages
-- opt.shortmess = "filnxtToOFWIcCs" --

-- Text
opt.joinspaces = false -- No double spaces with join after a dot
opt.whichwrap:append("[,],<,>,h,l") -- Allow arrow and hl to move cross lines

-- fix markdown indentation settings
vim.g.markdown_recommended_style = 0
