return {
  "folke/zen-mode.nvim", -- Zen mode
  dependencies = {
    "folke/twilight.nvim",
  },
  event = "VeryLazy",
  config = function()
    require("twilight").setup {
      context = 20,
    }
    require("zen-mode").setup {
      backdrop = 0.15,
      width = 160,
      plugins = {
        options = {
          ruler = true,
          -- showcmd = true,
        }
      }
    }
  end
}
