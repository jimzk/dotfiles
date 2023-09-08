return {
  "nvim-telescope/telescope-frecency.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "kkharji/sqlite.lua",
  },
  event = "VeryLazy",
  config = function()
    local ts = require("telescope")
    ts.setup {
      extensions = {
        frecency = {
          show_scores = false,
          show_unindexed = true,
          ignore_patterns = {
            "*.git/*",
            "/opt/homebrew/**/*.txt",
            vim.fn.stdpath("data") .. "/**/doc/*.txt"
          },
          disable_devicons = false,
          workspaces = {
            ["dot"] = vim.fs.normalize("~/.dotfiles"),
            ["conf"] = vim.fs.normalize("~/.config"),
            ["work"] = vim.fs.normalize("~/workspace"),
            ["desk"] = vim.fs.normalize("~/Desktop"),
            ["down"] = vim.fs.normalize("~/Downloads"),
            ["plug"] = vim.fn.stdpath("data") .. "/site/pack/packer",
          },
        }
      },
    }
    ts.load_extension("frecency")
  end
}
