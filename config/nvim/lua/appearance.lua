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

-- highlight when yanking
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank {
      higroup = 'Visual',
      timeout = 200
    }
    -- TODO: https://www.reddit.com/r/neovim/comments/wg4i1a/keep_cursor_position_on_yank/
    if vim.v.event.operator == "y" then
      vim.cmd "normal g`]"
    end
  end,
})
