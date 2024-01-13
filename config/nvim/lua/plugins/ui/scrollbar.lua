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
    excluded_filetypes = {
      "cmp_docs",
      "cmp_menu",
      "noice",
      "prompt",
      "TelescopePrompt",
      "dropbar_menu",
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
    local guifg = "#666c8d"
    vim.cmd("hi! ScrollbarHandle guibg=" .. guifg)
    vim.cmd("hi! ScrollbarSearchHandle guibg=" .. guifg)
    for _, key in ipairs({ "Add", "Change", "Delete" }) do
      vim.cmd("hi ScrollbarGit" .. key .. "Handle guibg=" .. guifg)
    end
  end,
}
