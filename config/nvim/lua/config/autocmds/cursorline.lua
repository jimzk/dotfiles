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
  -- "zsh",
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

vim.api.nvim_create_autocmd({
  -- "FocusGained",
  -- "WinEnter",
  -- "BufWinEnter",
  "InsertLeave",
}, {
  callback = function(opts)
    local ft = vim.bo[opts.buf].filetype
    if not vim.tbl_contains(ignored_fts, ft) then
      vim.o.cursorline = true
      -- vim.wo.relativenumber = true
    end
  end,
})

vim.api.nvim_create_autocmd({
  -- "FocusLost",
  -- "WinLeave",
  "InsertEnter",
}, {
  callback = function(opts)
    local ft = vim.bo[opts.buf].filetype
    if not vim.tbl_contains(ignored_fts, ft) then
      vim.wo.cursorline = false
      -- vim.wo.number = true
      -- vim.wo.relativenumber = false
    end
  end,
})
