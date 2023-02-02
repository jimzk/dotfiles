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
        text = "│",
      },
      GitChange = {
        text = "│",
      },
      GitDelete = {
        text = "│",
      },
      Search = {
        text = { "▪", "▪" },
      },
    },
  },
  config = function(_, opts)
    -- vim.cmd [[au ColorScheme * hi! ScrollbarSearch guifg=#81b29a]] -- IncSearch guibg
    -- vim.cmd [[au ColorScheme * hi! ScrollbarSearchHandle guifg=#81b29a]]
    require("scrollbar").setup(opts)
    require("scrollbar.handlers.gitsigns").setup()
    -- Customized highlights
    vim.cmd [[hi! ScrollbarHandle guibg=#51576d]]
    vim.cmd [[hi! ScrollbarSearchHandle guibg=#51576d]]
    for _, key in ipairs { "Add", "Change", "Delete" } do
      vim.cmd("hi ScrollbarGit" .. key .. "Handle guibg=#51576d")
    end
  end,
}
