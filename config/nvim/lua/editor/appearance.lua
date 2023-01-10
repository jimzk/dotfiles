vim.o.wrap = false
vim.o.signcolumn = 'yes'
vim.o.termguicolors = true

vim.o.cursorline = true
vim.o.cursorcolumn = false
vim.cmd [[
autocmd InsertLeave,WinEnter * set cursorline
autocmd InsertEnter,WinLeave * set nocursorline
]]

vim.o.relativenumber = true
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  pattern = "*",
  callback = function()
    local height = vim.api.nvim_win_get_height(0)
    vim.wo.scrolloff = height < 30 and 2 or 4
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
