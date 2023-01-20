return {
  "JoosepAlviste/nvim-ts-context-commentstring",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "tpope/vim-commentary",
  },
  event = "VeryLazy",
  config = function()
    require("nvim-treesitter.configs").setup({
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
    })
  end,
}
