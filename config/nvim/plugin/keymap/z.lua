local z = {
  -- fold
  o = "unfold",
  O = "unfold recursively",
  c = "fold",
  C = "fold recursively",
  a = "toggle fold",
  A = "toggle fold recursively",
  v = "show cursor line",
  M = "fold all",
  R = "unfold all",
  m = "fold more",
  r = "fold less",
  x = "update folds",
  -- locate
  z = "center cursor line",
  t = "top cursor line",
  b = "bottom cursor line",
  e = "scroll right",
  s = "scroll left",
  H = "half screen to the left",
  L = "half screen to the right",
  -- spelling
  g = "add word to spell list",
  w = "mark word as misspelling",
  ["="] = "spelling suggestions",
  -- matchup
  ["%"] = {"go to nearest (, { or [", mode = {"o", "n", "v"}},
}
require("which-key").register(z, { mode = "n", prefix = "z", preset = true })
