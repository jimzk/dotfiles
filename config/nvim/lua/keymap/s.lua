local ignored = {}
local ignore_char = function(c)
  vim.keymap.set("n", "s" .. c, "<esc>")
  ignored[c] = "which_key_ignore"
end
for i = 0, 26 do
  ignore_char(string.char(65 + i)) -- ignore A-Z
  ignore_char(string.char(97 + i)) -- ignore a-z
end

local wk = require("which-key")
wk.register(vim.tbl_extend("force", ignored, {
  name = "edit",
  -- splitjoin
  ["]"] = "[C] split line by syntax",
  ["["] = "[C] join line by syntax",
  -- treesitter-textobject
  p = { "swap current para with next" },
  P = { "swap current para with prev" },
}), { prefix = "s" })
