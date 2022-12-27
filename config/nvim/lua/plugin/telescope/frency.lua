-- https://github.com/nvim-telescope/telescope-frecency.nvim
local telescope = require("telescope")
telescope.setup {
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
telescope.load_extension("frecency")

-- Replace builtin.oldfiles
-- Seems not working if oldfiles is called inside other plugins.
-- require("telescope.builtin").olfiles = require("telescope").extensions.frecency.frecency
