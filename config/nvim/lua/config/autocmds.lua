-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

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

-- Set option buflisted
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "fugitive" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    -- vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Automatically show cursorline when entering a buffer
local ignored_fts = {
  "",
  "neo-tree",
  "aerial",
  "dashboard",
  "TelescopePrompt",
  -- "TelescopeResults",
  "help",
  "fugitiveblame",
  "NeogitStatus",
  "NeogitPopup",
  "lazy",
  "lazyterm",
  "lazygit",
  "mason",
  "toggleterm",
  "dropbar_menu",
  "notify",
  "kitty-scrollback",
  "zsh",
  "Trouble", -- v2
  "trouble", -- v3
  "markdown", -- for rust hover
  "oil",
  "oil_preview",
  "grapple",
  "rnvimr",
  "Navbuddy",
  "qf",
}

vim.api.nvim_create_autocmd({ "FocusGained", "InsertLeave", "WinEnter", "BufWinEnter" }, {
  callback = function(opts)
    local ft = vim.bo[opts.buf].filetype
    if not vim.tbl_contains(ignored_fts, ft) then
      vim.wo.cursorline = true
      -- vim.wo.relativenumber = true
    end
  end,
})

vim.api.nvim_create_autocmd({ "FocusLost", "InsertEnter", "WinLeave" }, {
  callback = function(opts)
    local ft = vim.bo[opts.buf].filetype
    if not vim.tbl_contains(ignored_fts, ft) then
      vim.wo.cursorline = false
      -- vim.wo.number = true
      -- vim.wo.relativenumber = false
    end
  end,
})

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

-- Auto saving files
-- * https://www.reddit.com/r/neovim/comments/1abd2cq/comment/kjss39u
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup("my_cfg", {})

---@type table<buffer, uv_timer_t>
local timers = {}
local timeout = 500

local function save(buf)
  vim.api.nvim_buf_call(buf, function()
    vim.cmd("noautocmd update")
  end)
end

autocmd({ "InsertLeave", "TextChanged" }, {
  group = augroup,
  desc = "Schedule auto-saving",
  callback = function(event)
    local bo = vim.bo[event.buf]
    if event.file == "" or bo.buftype ~= "" or bo.filetype == "gitcommit" or bo.readonly or not bo.modified then
      return
    end

    local timer = timers[event.buf]
    if timer then
      if timer:is_active() then
        timer:stop()
      end
    else
      -- timer = vim.uv.new_timer()
      timer = require("luv").new_timer()
      timers[event.buf] = timer
    end

    timer:start(
      timeout,
      0,
      vim.schedule_wrap(function()
        save(event.buf)
      end)
    )
  end,
})

autocmd({ "FocusLost", "ExitPre", "TermEnter" }, {
  group = augroup,
  desc = "Save immediately",
  callback = function(event)
    for buf, timer in pairs(timers) do
      if timer:is_active() then
        timer:stop()
        save(buf)
      end
    end
  end,
})

autocmd({ "BufWritePost", "InsertEnter" }, {
  group = augroup,
  desc = "Cancel scheduled auto-saving",
  callback = function(event)
    local timer = timers[event.buf]
    if timer and timer:is_active() then
      timer:stop()
    end
  end,
})

autocmd({ "BufDelete" }, {
  group = augroup,
  desc = "Remove timer",
  callback = function(event)
    local timer = timers[event.buf]
    if timer then
      timers[event.buf] = nil
      if timer:is_active() then
        timer:stop()
      end
      timer:close()
    end
  end,
})
