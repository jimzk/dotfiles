return {
  -- See https://github.com/hiasr/vim-zellij-navigator
  "swaits/zellij-nav.nvim",
  event = "VeryLazy",
  -- enabled = vim.fn.getenv("ZELLIJ") ~= vim.NIL,
  enabled = false,
  keys = {
    { "<C-h>", "<cmd>ZellijNavigateLeft<cr>", { silent = true, desc = "navigate left" } },
    { "<C-j>", "<cmd>ZellijNavigateDown<cr>", { silent = true, desc = "navigate down" } },
    { "<C-k>", "<cmd>ZellijNavigateUp<cr>", { silent = true, desc = "navigate up" } },
    { "<C-l>", "<cmd>ZellijNavigateRight<cr>", { silent = true, desc = "navigate right" } },
  },
  opts = {},
}
