
local wk = require("which-key")
local builtin = require("telescope.builtin")
local themes = require('telescope.themes')
local leader = {
  ["]"] = "add empty line bewlow",
  ["["] = "add empty line above",
  ["`"] = "last active tab",
  w = {"camelCase w", mode = {"n", "v", "o"}},
  b = {"camelCase b", mode = {"n", "v", "o"}},
  e = {"camelCase e", mode = {"n", "v", "o"}},
  ["ge"] = {"camelCase ge", mode = {"n", "v", "o"}},
  s = {
    name = "buffer",
    d = {"<cmd>bd<cr>", "delete current buffer (not close window)"},
    n = {"<cmd>edit<cr>", "new buffer"},
    e = {"<cmd>!open %<cr>", "open buffer by default appcalition"},
  },
  j = {
    name = "jump",
    j = {"g<tab>", "last tab"},
    p = {"gT", "previous tab"},
    n = {"gt", "next tab"},
  },
}
require("which-key").register(leader, {prefix = "<leader>"})

local vimer = {
  name = "vimer",
  -- Telescope
  h = {function() builtin.help_tags({
    -- previewer = false,
    -- layout_config = {
    --   width = 100,
    --   height = 0.5,
    --   anchor = "",
    -- },
  }) end, "show help keywords"},
  c = {"<cmd>Telescope commands<cr>", "avaliable commands"},
  C = {function() builtin.command_history({
    -- layout_config = {
    --     width = 100,
    -- }
  }) end, "command history"},
  r = {function() builtin.colorscheme({
    enable_preview = true,
    preview = false,
    -- layout_config = {  -- layout center
    --   anchor = "",
    --   mirror = true,
    -- }
  }) end, "avaliable colorschemes"},
  m = {"<cmd>Telescope keymaps<cr>", "keymaps in all modes"},
  o = {function() builtin.vim_options({
    -- layout_config = {
    --   width = 100,
    --   height = 0.5,
    -- }
  }) end, "Vim options"},
  l = {function() builtin.highlights({
    -- layout_config = {
    --   vertical = {
    --     width = 80,
    --     height = 0.5
    --   },
    --   horizontal = {
    --     width = 0.55
    --   },
    -- }
  }) end, "highlights"},
  a = {function() builtin.autocommands({
    previewer = false,
    -- layout_config = {
    --   vertical = {
    --     height = 0.5
    --   },
    --   horizontal = {
    --     width = 0.6
    --   },
    -- }
  }) end, "autocommands"},
  w = {"<cmd>Telescope loclist<cr>", "locations in current window"},
  v = {"<cmd>source $MYVIMRC<cr><cmd>runtime! plugin/**/*.vim plugin/**/*.lua<cr>", "reload vim configurations"},
  -- cheatsheet only for preview
  ["\\"] = {
    name = "cheatsheet",
  }
}
require("which-key").register(vimer, {prefix = [[<leader>\]]})
