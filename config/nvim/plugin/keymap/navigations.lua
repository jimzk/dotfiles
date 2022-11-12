local nav = {
  ["H"] = "home (top) line of screen",
  ["M"] = "middle line of screen",
  ["L"] = "last line of screen",
  ["]"] = {
    name = "next object",
    [")"] = "next )",
    ["}"] = "next }",
    [">"] = "next >",
    ["%"] = "next ), } or ]",
    m = "next method start",
    M = "next method end",
    s = "next misspelled word",
    c = "next git change",  -- gitsigns
  },
  ["["] = {
    name = "previous object",
    ["("] = "previous (",
    ["{"] = "previous {",
    ["<lt>"] = "previous <",
    ["%"] = "previous (, { or [",
    m = "previous method start",
    M = "previous method end",
    s = "previous misspelled word",
    c = "previous git change",  -- gitsigns
  },
}
require("which-key").register(nav, { mode = "n", prefix = "", preset = true })
require("which-key").register(nav, { mode = "o", prefix = "", preset = true })
