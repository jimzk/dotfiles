local  windows = {
  name = "window",
  -- new
  s = "split window",
  v = "split window vertically",
  n = "new buffer and split",
  N = {"<cmd>enew<cr>", "new buffer"},
  T = "break window into a new tab",
  f = "split file under cursor (see gf)",

  -- navigation
  ["^"] = "split alternative buffer #",
  w = "go next window",
  p = "✭ go last accessed window",
  h = "(hjkl) go left window",
  t = {"go top window"},  -- useless, can be removed in the future
  b = {"go bottom window"},  -- useless, can be removed in the future
  -- preview navigation
  P = {"go preview window"},
  z = {"close preview window"},

  -- close
  o = "close other windows",
  q = "quit window",

  -- layout
  r = {"rotate window layout"},  -- useless, can be removed in the future
  H = "(HJKL) move window to most left",
  x = "swap current window with next",
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

  -- coding (not much useful)
  -- d = {"go definition under cursor and split"},
  -- i = {"go declaration under cursor and split"},
}
require("which-key").register(windows, { mode = "n", prefix = "<c-w>", preset = true })

-- -- Alias ,, to <C-w>
-- local cc = {}
-- for k, v in pairs(windows) do
--   if k == "which_key_ignore" then
--     ::continue::
--   end
--   if k == "name" or (type(v) == "table" and #v ~= 1) then
--     cc[k] = v
--   else
--     cc[k] = {"<C-w>" .. k}
--     if type(v) == "table" then
--       table.insert(cc[k], v[1])
--     else
--       table.insert(cc[k], v)
--     end
--   end
-- end
-- require("which-key").register(cc, { mode = "n", prefix = ",," })
