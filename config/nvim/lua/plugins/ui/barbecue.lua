return {
  -- VSCode like winbar
  "utilyre/barbecue.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "SmiteshP/nvim-navic",
  },
  enabled = false,
  event = "BufReadPost",
  opts = {
    include_buftypes = { "", "acwrite", "help", "quickfix", "nofile", "notwrite" },
    exclude_filetypes = { "markdown", "neo-tree", "toggleterm" },
    -- custom_section = function()
    --   return " " .. os.date("%R")
    -- end,
    -- NOTE: not support dim_inactive mode
    theme = "catppuccin",
    -- theme = {
    --   basename = { fg = "#dddddd" },
    -- },
    show_modified = true,
    show_navic = false,
  },
  config = function(_, opts)
    require("barbecue").setup(opts)
    -- Default autocmd results in error when using vim.ui.input, so I create by myself
    vim.api.nvim_create_autocmd({
      -- "WinScrolled",
      "BufWinEnter",
      -- "CursorHold",
      -- "InsertLeave",
    }, {
      group = vim.api.nvim_create_augroup("barbecue.updater", {}),
      callback = function()
        require("barbecue.ui").update()
      end,
    })
  end,
}
