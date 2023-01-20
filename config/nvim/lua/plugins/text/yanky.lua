local ignored = "which_key_ignore"
return {
  "gbprod/yanky.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = "VeryLazy",
  keys = {
    -- Smart put
    { "p", "<Plug>(YankyPutAfter)", desc = ignored },
    { "P", "<Plug>(YankyPutBefore)", desc = ignored },
    -- No yank at visual put
    { "p", "<Plug>(YankyPutAfterCharwise)", mode = "x", desc = ignored },
    { "P", "<Plug>(YankyPutAfterCharwise)", mode = "x", desc = ignored },
    -- Yank linewise
    { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = ignored },
    { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = ignored },

    -- Preserve cursor position on yank
    { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = ignored },
    { "Y", "<Plug>(YankyYank)$", mode = { "n", "x" }, desc = ignored },

    { "<C-}>", "<Plug>(YankyCycleForward)", desc = ignored },
    { "<C-{>", "<Plug>(YankyCycleBackward)", desc = ignored },

    { "<leader>jp", "<cmd>Telescope yank_history<cr>", desc = "yank history" },
  }, --
  opts = {
    highlight = {
      on_put = false,
      on_yank = false,
    },
    preserve_cursor_position = {
      enabled = true,
    },
  },
  config = function(_, opts)
    require("yanky").setup(opts)
    require("telescope").load_extension("yank_history")
  end,
}
