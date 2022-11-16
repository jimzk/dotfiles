-- make visual color more clear
-- vim.cmd("au ColorScheme * hi! link Visual Search")

vim.opt.cursorline = true
vim.opt.termguicolors = true

-- highlight when yanking
vim.api.nvim_create_autocmd('TextYankPost',{
  callback = function()
    vim.highlight.on_yank {
      higroup = 'IncSearch',
      timeout = 150
    }
  end,
})
