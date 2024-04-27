-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

require("config.autocmds.auto-save")
-- require("config.autocmds.cursorline")

-- Jump to last visited place when entering a bufer
-- * https://this-week-in-neovim.org/2023/Jan/02#tips
-- * https://www.reddit.com/r/neovim/comments/1abd2cq/comment/kjmv9jz
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
      -- pcall(vim.api.nvim_win_set_cursor, 0, mark)
      vim.api.nvim_win_set_cursor(0, mark)
      -- set mark ` to last visited place as well
      vim.api.nvim_buf_set_mark(0, "`", mark[1], mark[2], {})
    end
  end,
})

-- Set files under certain directories unmodifiable
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = {
    "**/.cargo/registry/**",
    "**/.cargo/git/**",
    "**/.local/share/nvim/lazy/**",
  },
  callback = function(opts)
    local bufnr = opts.buf
    vim.bo[bufnr].readonly = true
    vim.bo[bufnr].modifiable = false
    vim.bo[bufnr].buflisted = false
    vim.bo[bufnr].swapfile = false
  end,
})
