local builtin = require("telescope.builtin")

local leader_c = {
  name = "coding",
  q = { function()
    builtin.quickfix({
      prompt_title = "Quickfix List",
    })
  end, "quickfix list (telescope)" },
  w = { "<cmd>Telescope loclist<cr>", "location list (telescope)" },
  i = { "<cmd>CmpStatus<cr>", "cmp (completion) status" },
  r = { "<cmd>Telescope registers<cr>", "paste from register" },
  t = { "<cmd>TroubleToggle telescope<cr>", "toggle telescope items (trouble)" },
}
require("which-key").register(leader_c, { prefix = "<leader>c" })
