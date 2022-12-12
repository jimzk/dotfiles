local wk = require("which-key")

local cht = {
  -- cheatsheet only for preview
  name = "cheatsheet",
  b = { "<cmd>h :unlisted-buffer<cr>", "meaning of buffer status" },
  k = { "<cmd>h map-table<cr>", "mapping type" },
  t = { "<cmd>!open https://github.com/nvim-telescope/telescope-fzf-native.nvim<cr>", "telescope search syntax" },
  v = { "<cmd>!open https://github.com/mg979/vim-visual-multi<cr>", "multi select guide" },
  x = {
    name = "diagnostics list (Trouble.nvim)",
    ["1"] = "<esc> close list and go back",
    ["q"] = "close list",
    ["r"] = "manually refresh",
    ["<cr>"] = "jump to item or toggle folds",
    ["<c-x>"] = "open in split",
    ["<c-v>"] = "open in vplist",
    ["<c-t>"] = "open in new tab",
    ["o"] = "jump to item and close list",
    ["m"] = [[toggle workspace/document mode]],
    ["P"] = "toggle auto_preview",
    ["K"] = "popup for the full message",
    ["p"] = "preview diagnostic location",
    z = {
      name = "fold",
      m = "zm close folds",
      M = "zM close all folds",
      r = "zr open folds",
      R = "zR open all folds",
      a = "za toggle folds",
      A = "zA toggle folds recursively",
    },
    ["k"] = "previous item",
    ["j"] = "next item",
  },
  d = {
    name = "how to read doc",
    ["0"] = { "CTRL ] go tag" },
    ["1"] = { "CTRL-O or CTRL-T go back" },
    ["2"] = { "CTRL-T go forward" },
    ["3"] = { "gO shows outline" },
    ["7"] = { "CTRL-W f split file under cursor" },
    ["8"] = { "CTRL-W ] split tag under cursor" },
    ["9"] = { "CTRL-] go tag" },

    ["a"] = { "CTRL-W } open tag in preview window" },
    ["b"] = { "CTRL-W P go preview window" },
    ["c"] = { "CTRL-W z close preview window" },

    ["A"] = { ":h :put documentation for :put" }
  },
  ["0"] = {
    name = "efficiency",
    ["0"] = "_/g_ replace ^/$",
    ["1"] = "-/+ replace j/k",
    ["2"] = "gi re-insert, gv re-select",
    ["3"] = "<C-w>p go to latest window",
    ["4"] = "viq select current/next quotes content",
    ["5"] = "cina jump and delete next argument",
    ["6"] = "<leader>r resumes last telescope",
    ["7"] = "paragraph is the content between two blanklines",
  },
  ["1"] = {
    name = "useful commands (range)",
    ["0"] = { "[range]{cmd}[x] basic form" },
    ["1"] = { ":5,10m2 move L#5~10 after L#2" },
    ["2"] = { ":5,10m$ move after file end" },
    ["3"] = { ":5,10m. move after current line" },
    ["4"] = { ":5,10m.+3 move after current L#+3" },
    ["5"] = { ":5,10m'a move after mark a" },
    ["6"] = { "similar commands: :y :d :t :j :p" },
    ["7"] = { ":put % write content in register % under cursor" },
    ["8"] = { ":put=execute('!ls') write command result under cursor" },
    ["9"] = { ":10r!ls write command result under L#10" },
    ["!"] = { ":5,10norm {cmd} execute command on L#5~10" },

    ["a"] = { ":1,10w !sh execute shell code in L#1~10" },
    ["b"] = { ":1,10w !sh execute shell code and replace" },
    ["c"] = { ":w !sudo tee% write file by sudo" },
    ["d"] = { ":1,10!sort sort L#1~10 and replace" },
    ["e"] = { ":1,10!python3 execute python code" }
  },
  ["2"] = {
    name = "useful commands",
    ["0"] = { ":0file", "remove current file name" },
  }
}
wk.register(cht, { prefix = "<leader>,", silent = true })
