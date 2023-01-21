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
    exclude_filetypes = { "neo-tree" },
    -- custom_section = function()
    -- return " " .. os.date("%R")
    -- end,
    theme = {
      basename = { fg = "#dddddd" },
    },
  },
}
