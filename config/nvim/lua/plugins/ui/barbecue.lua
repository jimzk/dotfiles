return {
  -- VSCode like winbar
  "utilyre/barbecue.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "SmiteshP/nvim-navic",
  },
  event = "VeryLazy",
  opts = {
    include_buftypes = { "", "acwrite", "help", "quickfix", "nofile", "notwrite" },
    exclude_filetypes = { "neo-tree", "toggleterm" },
    -- custom_section = function()
    -- return " " .. os.date("%R")
    -- end,
    theme = {
      basename = { fg = "#dddddd" },
    },
    create_autocmd = false, -- prevent barbecue from updating itself automatically
  },
  config = function(_, opts)
    require("barbecue").setup(opts)
    -- Default autocmd results in error when using vim.ui.input, so I create by myself
    vim.api.nvim_create_autocmd({
      "WinScrolled",
      "BufWinEnter",
      "CursorHold",
      "InsertLeave",
    },
      { group = vim.api.nvim_create_augroup("barbecue.updater", {}),
        callback = function()
          require("barbecue.ui").update()
        end,
      })
  end
}
