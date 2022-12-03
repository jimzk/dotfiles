local builtin = require("telescope.builtin")

local leader_c = {
  name = "coding",
  q = { function()
    builtin.quickfix({
      prompt_title = "Quickfix List",
    })
  end, "quickfix list (telescope)" },
  w = { "<cmd>Telescope loclist<cr>", "location list (telescope)" },
  s = { "<cmd>CmpStatus<cr>", "cmp (completion) status" },
  r = { "<cmd>Telescope registers<cr>", "paste from register" },
  F = { "gg=G``", "format file (by treesitter)" }, -- lsp.lua set another format way by lsp
  t = { "<cmd>TroubleToggle telescope<cr>", "toggle telescope items (trouble)" },
  -- treesitter-textobject
  p = { "swap current para with next" },
  P = { "swap current para with prev" },
}
require("which-key").register(leader_c, { prefix = "<leader>c" })
