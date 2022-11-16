local builtin = require("telescope.builtin")

local leader_c = {
  name = "coding",
  q = {function() builtin.quickfix({
      prompt_title = "Quick Fix",
    }) end, "list items in quickfix"},
  s = {"<cmd>CmpStatus<cr>", "cmp (completion) status"},
  F = {"gg=G``", "format file (by treesitter)"},  -- lsp.lua set another format way by lsp
}
require("which-key").register(leader_c, {prefix = "<leader>c"})
