
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
  h = {
    name = "buffer & tab",
    h = {"g<tab>", "last tab"},
    j = {"gT", "previous tab"},
    k = {"gt", "next tab"},
    d = {"<cmd>bd<cr>", "delete current buffer (leave window)"},
    n = {"<cmd>edit<cr>", "new buffer"},
    e = {"<cmd>!open %<cr>", "open buffer by default appcalition"},
    q = {"<cmd>q<cr>", "quite"},
    ["1"] = {"<cmd>q!<cr>", "quite forcely"},
    w = {"<cmd>w<cr>", "write"},
    ["<tab>"] = {"<cmd>wq<cr>", "write and quit"},
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
    d = {
      name = "read documentation",
      ["0"] = {"CTRL ] go to tag"},
      ["1"] = {"CTRL-O or CTRL-T go back"},
      ["2"] = {"CTRL-T go forward"},
      ["3"] = {"gO shows outline"},
      ["7"] = {"CTRL-W f edit file under cursor and split"},
      ["8"] = {"CTRL-W ] go to tag and split window"},
      ["9"] = {"CTRL-] go to tag"},

      ["a"] = {"CTRL-W } open tag in preview window"},
      ["b"] = {"CTRL-W P go to preview window"},
      ["c"] = {"CTRL-W z close preview window"},

      ["A"] = {":h :put documentation for :put"}
    },
    c = {
      name = "useful commands",
      ["0"] = {"[range]{cmd}[x] basic form"},
      ["1"] = {":5,10m2 move L#5~10 after L#2"},
      ["2"] = {":5,10m$ move after file end"},
      ["3"] = {":5,10t. move after current line"},
      ["4"] = {":5,10t.+3 move after current L#+3"},
      ["5"] = {":5,10m'a move after mark a"},
      ["6"] = {"similar commands: :y :d :t :j :p"},
      ["7"] = {":put % write content in register % under cursor"},
      ["8"] = {":put=execute('!ls') write command result under cursor"},
      ["9"] = {":10r!ls write command result under L#10"},
      ["!"] = {":5,10norm {cmd} execute command on L#5~10"},

      ["a"] = {":1,10w !sh execute shell code in L#1~10"},
      ["b"] = {":1,10w !sh execute shell code and replace"},
      ["c"] = {":w !sudo tee% write file by sudo"},
      ["d"] = {":1,10!sort sort L#1~10 and replace"},
      ["e"] = {":1,10!python3 execute python code"}
    }
  }
}
require("which-key").register(vimer, {prefix = [[<leader>\]]})
