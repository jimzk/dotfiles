local wk = require("which-key")
local opt = { mode = "n", prefix = "<c-w>", preset = true }
wk.register({
  name = "window",
  -- new
  s = "split window",
  v = "split window vertically",
  n = "new buffer and split",
  N = { "<cmd>enew<cr>", "new buffer" },
  T = { function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd [[tabnew %]]
    vim.api.nvim_win_set_cursor(0, pos)
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

  -- coding (not much useful)
  -- d = {"go definition under cursor and split"},
  -- i = {"go declaration under cursor and split"},
}, opt)

vim.cmd [[
nnoremap <silent> <c-w><c--> <c-w>_
nnoremap <silent> <c-w><c-\> <c-w>\|
nnoremap <silent> <c-w><c-=> <c-w>=
]]
wk.register({
  -- maximize and restore layout
  ["<C-=>"] = "equally size",
  ["<C-->"] = "max out height",
  ["<C-\\>"] = "max out width",
}, opt)
