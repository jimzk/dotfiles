return {
  "JoosepAlviste/nvim-ts-context-commentstring",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "tpope/vim-commentary",
  },
  event = "VeryLazy",
  config = function()
    -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring/wiki/Integrations#plugins-with-a-pre-comment-hook
    vim.g.skip_ts_context_commentstring_module = true
    require("ts_context_commentstring").setup {
      enable_autocmd = false,
    }
  end,
}
