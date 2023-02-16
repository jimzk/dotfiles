return {
  "petertriho/nvim-scrollbar",
  event = "VeryLazy",
  opts = {
    handlers = {
      color = "#36454F", -- current bar color
      diagnostic = false,
      cursor = false,
      gitsigns = true,
    },
    marks = {
      GitAdd = {
        text = "+",
      },
      GitChange = {
        text = "┆",
      },
      GitDelete = {
        text = "-",
      },
      Search = {
        text = { ".", "." },
      },
    },
  },
  config = function(_, opts)
    -- vim.cmd [[au ColorScheme * hi! ScrollbarSearch guifg=#81b29a]] -- IncSearch guibg
    -- vim.cmd [[au ColorScheme * hi! ScrollbarSearchHandle guifg=#81b29a]]
    require("scrollbar").setup(opts)
    require("scrollbar.handlers.gitsigns").setup()
  end,
}
