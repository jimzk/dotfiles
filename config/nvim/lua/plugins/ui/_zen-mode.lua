return {
  "folke/zen-mode.nvim", -- Zen mode
  enabled = false,
  keys = {
    { "<leader>z", "<cmd>ZenMode<cr>", desc = "zen mode" }
  },
  opts = {
    backdrop = 0.15,
    width = 160,
    options = {
      list = true,
    },
    plugins = {
      options = {
        ruler = true,
        showcmd = true,
      },
      gitsigns = {
        enabled = true,
      },
    }
  },
}
