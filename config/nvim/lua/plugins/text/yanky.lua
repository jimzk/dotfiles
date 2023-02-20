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
    { "p", function()
      local mode = vim.fn.mode()
      -- Respect indentation in current context if selection is linewise
      return mode == "V"
          and "<Plug>(YankyPutIndentAfterLinewise)"
          or "<Plug>(YankyPutAfterCharwise)"
    end, mode = "x", desc = ignored, expr = true },
    { "P", "p", mode = "x", desc = ignored, remap = true },
    -- Yank linewise
    { "]p", "<Plug>(YankyPutIndentAfterLinewise)", mode = { "n", "x" }, desc = "put the yanked up linewise" },
    { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", mode = { "n", "x" }, desc = "put the yanked down linewise" },

    -- Preserve cursor position on yank
    { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = ignored },
    { "Y", "<Plug>(YankyYank)$", mode = { "n", "x" }, desc = ignored },

    { "]y", "<Plug>(YankyCycleForward)", desc = "put the next yanked" },
    { "[y", "<Plug>(YankyCycleBackward)", desc = "put the prev yanked" },

    -- { "<leader>jp", "<cmd>Telescope yank_history<cr>", desc = "yank history" },
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
