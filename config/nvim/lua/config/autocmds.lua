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

-- https://www.reddit.com/r/neovim/comments/10rhoxs/how_to_make_scrolloff_option_scroll_past_end_of/
-- Keep cursor centered when moving
-- vim.cmd [[autocmd CursorMoved * normal! zz]]

-- resize splits if window got resized
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

-- Auto save
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
  callback = function(opts)
    local bufnr = opts.buf
    local bo = vim.bo[bufnr]
    -- OverseerFrom file's buflisted will be reset to true. Handle specially.
    if bo.filetype == "OverseerForm" then return end
    if bo.modifiable and bo.buflisted and vim.api.nvim_buf_get_name(0) ~= "" then
      vim.cmd [[up]]
    end
  end,
})

-- number column
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  callback = function(opts)
    local ft = vim.bo[opts.buf].filetype
    if not vim.tbl_contains({ "alpha" }, ft) then
      vim.wo.cursorline = true
    end
  end,
})
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  callback = function()
    vim.wo.cursorline = false
  end,
})

vim.api.nvim_create_autocmd({ "WinEnter", "FocusGained" }, {
  callback = function()
    -- local height = vim.api.nvim_win_get_height(0)
    -- vim.wo.scrolloff = height < 30 and 3 or 8
    --
    -- if vim.wo.number then vim.wo.relativenumber = true end
    -- vim.wo.wrap = true
  end,
})
vim.api.nvim_create_autocmd({ "WinLeave", "FocusLost" }, {
  pattern = "*",
  callback = function()
    -- if vim.wo.number then vim.wo.relativenumber = false end
    -- vim.wo.wrap = false
  end,
})

-- set option buflisted
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
