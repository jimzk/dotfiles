local g = {
  name = "go",
  ["%"] = {"cycle through brackets", mode = {"n", "v", "o"}},
  f = "go to file under cursor",
  x = "open the file under cursor with system app",
  i = "insert in last insertion (mark ^)",
  I = "insert in star of last insertion",
  v = "visual last selection",
  c = {
    name = "line comment",
    mode = {"n", "v", "o"},
    c = "comment line",
    u = "uncomment block",
  },
  u = "lowercase",
  U = "uppercase",
  J = "joins lines and keep leading spaces",
  S = "splits line by syntax",
  p = "paste before char ",
  d = "definition under cursor",
  t = "next tab",
  T = "previous tab",
  ["<tab>"] = "last accessed tab",
  [";"] = "older change position",
  [","] = "newer change position",
  ["'"] = "go to mark without changing jumplist",
  ["`"] = "which_key_ignore",
}
require("which-key").register(g, { mode = "n", prefix = "g", preset = true })
