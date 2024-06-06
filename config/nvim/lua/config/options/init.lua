-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

-- Always center cursor
opt.scrolloff = 7
opt.sidescrolloff = 0
-- preview %s command in split window
-- https://www.reddit.com/r/neovim/comments/1cytkbq/comment/l5bxr3v
opt.inccommand = "split"
-- Only highlight cursor line number
-- opt.cursorline = true
-- opt.cursorlineopt = "number"

opt.relativenumber = false
opt.wrap = false

opt.autoread = true
opt.autowrite = true -- enable auto write
opt.clipboard = "unnamedplus" -- sync with system clipboard

opt.swapfile = false
opt.backup = false -- Don't backup file while overwriting file

opt.conceallevel = 3
opt.incsearch = true

-- stack:  -- Make jumplist behave like web browser back / forward
-- https://www.reddit.com/r/neovim/comments/11dmaed/keep_buffer_view_when_you_return_to_file/
-- https://www.reddit.com/r/neovim/comments/16nead7/comment/k1e1nj5/
opt.jumpoptions = "stack,view" -- view: keep view of the buffer

opt.showtabline = 2 -- Always show tabline

-- Window border
-- From: https://github.com/echasnovski/mini.basics/blob/main/lua/mini/basics.lua#L477
-- opt.fillchars = [[eob: ,fold: ,foldopen: ,foldsep: ,foldclose:]]

-- stylua: ignore
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

-- Define which helper symbols to show
opt.listchars = {
  tab = "> ",
  trail = "·",
  nbsp = "+",
  extends = "…",
  precedes = "…",
}

-- Text
opt.joinspaces = false -- No double spaces with join after a dot
opt.whichwrap:append("[,],<,>,h,l") -- Allow arrow and hl to move cross lines

opt.sessionoptions = {
  "blank",
  "buffers",
  "curdir",
  "folds",
  "help",
  "tabpages",
  "winpos",
  "winsize",
  "terminal",
  "localoptions",
}

require("config.options.abbr")
require("config.options.search")
require("config.options.qf")
require("config.options.commands")
require("config.options.neovide")
