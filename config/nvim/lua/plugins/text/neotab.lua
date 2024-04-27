return {
  -- neotab doesn't use treesitter
  "kawre/neotab.nvim",
  event = "InsertEnter",
  enabled = true,
  dependencies = {
    {
      "abecodes/tabout.nvim",
      enabled = false,
    },
    "hrsh7th/nvim-cmp", -- Should load after cmp
  },
  opts = {
    act_as_tab = false,
    behavior = "closing",
  },
}
