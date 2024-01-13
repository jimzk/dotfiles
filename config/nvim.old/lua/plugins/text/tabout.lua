return {
  "abecodes/tabout.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp", -- Should load after cmp
  },
  event = "InsertEnter",
  opts = {
    backwards_tabkey = "",
  },
}
