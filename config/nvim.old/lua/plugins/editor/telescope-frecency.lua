return {
  "nvim-telescope/telescope-frecency.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  event = "VeryLazy",
  -- enabled = false,
  keys = {
    -- {
    --   "<leader>fo",
    --   function()
    --     require("telescope").extensions.frecency.frecency({
    --       prompt_title = "Oldfiles (cwd)",
    --       workspace = "CWD",
    --     })
    --   end,
    --   desc = "old files (cwd)",
    -- },
    {
      "<leader>fo",
      function()
        require("telescope").extensions.frecency.frecency({
          prompt_title = "Oldfiles (global)",
        })
      end,
      desc = "old files (global)",
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
            ["dotfile"] = vim.fs.normalize("~/.dotfiles"),
            ["config"] = vim.fs.normalize("~/.config"),
            ["workspace"] = vim.fs.normalize("~/workspace"),
            ["desktop"] = vim.fs.normalize("~/Desktop"),
            ["download"] = vim.fs.normalize("~/Downloads"),
            ["plugins"] = vim.fn.stdpath("data") .. "/lazy",
          },
        },
      },
    })
    ts.load_extension("frecency")
  end,
}
