-- This file is automatically loaded by plugins.init

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, { command = "checktime" })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({
      timeout = 200,
    })
  end,
})

-- resize splits if window got resized
-- stylua: ignore
vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd("tabdo wincmd =")
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

-- Jump to last visited place when entering a bufer
-- https://this-week-in-neovim.org/2023/Jan/02#tips
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
      -- set mark ` to last visited place as well
      vim.api.nvim_buf_set_mark(0, "`", mark[1], mark[2], {})
    end
  end,
})

vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  callback = function()
    if vim.bo.buflisted then vim.wo.cursorline = true end
  end,
})
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  callback = function()
    if vim.bo.buflisted then vim.wo.cursorline = false end
  end,
})

vim.api.nvim_create_autocmd({ "WinEnter", "FocusGained" }, {
  callback = function()
    local height = vim.api.nvim_win_get_height(0)
    vim.wo.scrolloff = height < 30 and 1 or 3
    if vim.wo.number then vim.wo.relativenumber = true end
  end,
})
vim.api.nvim_create_autocmd({ "WinLeave", "FocusLost" }, {
  pattern = "*",
  callback = function()
    if vim.wo.number then vim.wo.relativenumber = false end
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  pattern = Util.unlisted_filetypes,
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    -- vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})
