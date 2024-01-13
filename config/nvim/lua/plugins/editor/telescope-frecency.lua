return {
  "nvim-telescope/telescope-frecency.nvim",
  event = "VeryLazy",
  enabled = false,
  keys = {
    {
      "<leader>fR",
      function()
        require("telescope").extensions.frecency.frecency({
          prompt_title = "Frecency (Global)",
        })
      end,
      desc = "Frecency (Global)",
    },
    {
      "<leader>fr",
      function()
        require("telescope").extensions.frecency.frecency({
          workspace = "CWD",
          prompt_title = "Frecency (CWD)",
        })
      end,
      desc = "Frecency",
    },
  },
  config = function()
    local ts = require("telescope")
    ts.setup({
      extensions = {
        frecency = {
          show_scores = true,
          show_unindexed = true,
          ignore_patterns = {
            "*.git/*",
            "/opt/homebrew/**/*.txt",
            vim.fn.stdpath("data") .. "/**/doc/*.txt",
          },
          disable_devicons = false,
          workspaces = {
            -- :dot search files in ~/.dotfiles/
            ["do"] = vim.fs.normalize("~/.dotfiles"),
            ["config"] = vim.fs.normalize("~/.config"),
            ["workspace"] = vim.fs.normalize("~/workspace"),
            ["desktop"] = vim.fs.normalize("~/Desktop"),
            ["download"] = vim.fs.normalize("~/Downloads"),
          },
        },
      },
    })
    ts.load_extension("frecency")
  end,
}
