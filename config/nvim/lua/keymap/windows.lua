local windows = {
  name = "window",
  -- new
  s = "split window",
  v = "split window vertically",
  n = "new buffer and split",
  N = { "<cmd>enew<cr>", "new buffer" },
  T = { function()
    vim.cmd [[tabnew %]]
  end, "break window into new tab" },
  f = "split file under cursor (see gf)",

  -- navigation
  ["^"] = "split alternative buffer #",
  w = "go next window",
  p = "✭ go last accessed window",
  h = "(hjkl) go left window",
  t = { "go top window" },
  b = { "go bottom window" },
  -- preview navigation
  P = { "go preview window" },
  z = { "close preview window" },

  -- close
  o = "close other windows",
  c = "close window",

  -- layout
  r = { "rotate window layout" }, -- useless, can be removed in the future
  H = "(HJKL) move window to most left",
  x = "swap current window with next",
  ["-"] = "decrease height",
  ["+"] = "increase height",
  ["<lt>"] = "decrease width",
  [">"] = "increase width",
  -- maximize adn restore layout
  ["<C-=>"] = "max out width",
  ["<C-->"] = "max out height",
  ["<C-\\>"] = "equally size",

  -- coding (not much useful)
  -- d = {"go definition under cursor and split"},
  -- i = {"go declaration under cursor and split"},
}
require("which-key").register(windows, { mode = "n", prefix = "<c-w>", preset = true })
