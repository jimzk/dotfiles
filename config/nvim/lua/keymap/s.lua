local wk = require("which-key")
local opts = { mode = "n", prefix = "s", preset = true }
wk.register({
  name = "edit",
  -- splitjoin
  ["]"] = "[C] split line by syntax",
  ["["] = "[C] join line by syntax",
  -- treesitter-textobject
  p = { "swap para with next" },
  P = { "swap para with prev" },
}, opts)
