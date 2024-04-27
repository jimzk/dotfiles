return {
  "abecodes/tabout.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp", -- Should load after cmp
  },
  event = "InsertEnter",
  opts = {
    backwards_tabkey = "",
    act_as_tab = false,
    enable_backwards = false,
    ignore_beginning = false,
  },
  config = function(_, opts)
    require("tabout").setup(opts)
  end,
}
