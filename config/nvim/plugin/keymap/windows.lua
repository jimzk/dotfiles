local  windows = {
  name = "window",
  -- new
  s = "split window",
  v = "split window vertically",
  n = "new buffer and split",
  N = {"<cmd>enew<cr>", "new buffer"},
  y = {"<cmd>NvimTreeToggle<cr>", "open file explorer"},
  ["<C-y>"] = {"<cmd>NvimTreeToggle<cr>", "which_key_ignore"},
  Y = {"<cmd>NvimTreeFindFile!<cr>", "open file explorer and locate"},
  T = "break window into a new tab",

  -- navigation
  ["<C-6>"] = "(^) open buffer # and split",
  w = "next window",
  p = "last accessed window",
  h = "(hjkl) go to left window",
  t = {"top window"},  -- useless, can be removed in the future
  b = {"bottom window"},  -- useless, can be removed in the future
  -- preview navigation
  P = {"go to preview window"},
  z = {"close preview window"},

  -- close
  o = "close other windows",
  q = "quit window",
  Q = {"<cmd>q!<cr>", "quit window forcely"},

  -- layout
  r = {"rotate window layout"},  -- useless, can be removed in the future
  H = "(HJKL) move window to most left",
  x = "swap current with next",
  ["-"] = "decrease height",
  ["+"] = "increase height",
  ["<lt>"] = "decrease width",
  [">"] = "increase width",
  -- maximize adn restore layout
  ["|"] = "which_key_ignore",
  ["<C-\\>"] = "max out the width",
  ["_"] = "which_key_ignore",
  ["<C-->"] = "max out the height",
  ["<C-=>"] = "equally high and wide",

  -- coding
  d = {"definition under cursor and split"},
  i = {"declaration under cursor and split"},
}
require("which-key").register(windows, { mode = "n", prefix = "<c-w>", preset = true })
