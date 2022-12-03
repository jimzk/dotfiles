local builtin = require("telescope.builtin")

local leader_c = {
  name = "coding",
  p = { "swap current parameter with next" }, -- Supported by treesitter-textobject
  P = { "swap current parameter with previous" }, -- Supported by treesitter-textobject
  q = { function() builtin.quickfix({
      prompt_title = "Quick Fix",
    })
  end, "list items in quickfix" },
  s = { "<cmd>CmpStatus<cr>", "cmp (completion) status" },
  F = { "gg=G``", "format file (by treesitter)" }, -- lsp.lua set another format way by lsp
}
require("which-key").register(leader_c, { prefix = "<leader>c" })
