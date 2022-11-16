require("which-key").register({
  -- wording
  j = "which_key_ignore",
  k = "which_key_ignore",
  y = {
    name = "copy",
    s = {
      s = "yss) add () to entire line",
    }
  },
  Y = {"yank entire line"},
  U = {"redo"},
  ["<C-y>"] = {"scroll up"},
  ["<C-e"] = {"scroll down"},
  ["<C-g"] = {"print current file name"},
  ["<lt>"] = {"indent left"},
  [">"] = {"indent right"},
  -- vim-expand-region
  ["+"] = "expand selection",
  ["_"] = "shrink selection",
  v = {
    name = "visual",
    ["+"] = {"expand selection"},
    ["_"] = {"shrink selection"},
  },
}, {prefix = "", preset = true})
