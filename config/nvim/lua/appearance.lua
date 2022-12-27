vim.o.signcolumn = 'yes'
vim.o.termguicolors = true
vim.o.cursorline = true
vim.o.cursorcolumn = false

vim.o.relativenumber = false
vim.api.nvim_create_autocmd("WinEnter", {
  pattern = "*",
  callback = function()
    local height = vim.api.nvim_win_get_height(0)
    vim.wo.scrolloff = height < 30 and 2 or 5
    if vim.wo.number then
      vim.wo.relativenumber = true
    end
  end
})
vim.api.nvim_create_autocmd("WinLeave", {
  pattern = "*",
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = false
    end
  end
})

-- highlight when yanking
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank {
      higroup = 'Visual',
      timeout = 200
    }
  end,
})
