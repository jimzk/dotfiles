-- Make visual highlight more clear
-- vim.cmd [[au ColorScheme * hi! link Visual Search]]
-- vim.cmd [[au ColorScheme * hi! Visual guifg=reverse]]
vim.cmd [[au ColorScheme * hi! Visual guibg=#404e62]]

vim.o.termguicolors = true
vim.o.cursorline = true
vim.o.cursorcolumn = false

-- highlight when yanking
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank {
      higroup = 'IncSearch',
      timeout = 200
    }
  end,
})
