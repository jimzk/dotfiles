-- Show LSP information on mouse hover
return {
  "soulis-1256/eagle.nvim",
  event = "VeryLazy",
  enabled = false,
  init = function()
    vim.o.mousemoveevent = true
  end,
  opts = {},
}
