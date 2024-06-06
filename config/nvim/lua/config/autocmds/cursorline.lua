-- Automatically show cursorline when entering a buffer
local ignored_fts = {
  "",
  "neo-tree",
  -- "aerial",
  "dashboard",
  "TelescopePrompt",
  -- "TelescopeResults",
  -- "help",
  "fugitiveblame",
  "NeogitStatus",
  "NeogitPopup",
  -- "lazy",
  "lazyterm",
  "lazygit",
  "mason",
  "toggleterm",
  "dropbar_menu",
  "notify",
  "kitty-scrollback",
  -- "zsh",
  "trouble",
  "markdown", -- for rust hover
  "oil",
  "oil_preview",
  "grapple",
  "rnvimr",
  "Navbuddy",
  "spectre_panel",
  "qf",
  "PlenaryTestPopup",
  "lspinfo",
  "startuptime",
  "tsplayground",
  "neotest-output",
  "checkhealth",
  "neotest-summary",
  "neotest-output-panel",
}

vim.api.nvim_create_autocmd({
  "FocusGained",
  "WinEnter",
  "BufWinEnter",
  "InsertLeave",
}, {
  callback = function(opts)
    local ft = vim.bo[opts.buf].filetype
    local bt = vim.bo[opts.buf].buftype
    -- if not (bt == "nofile" or bt == "") then
    if bt == "" or bt == "help" then
      -- if not vim.tbl_contains(ignored_fts, ft) then
      vim.wo.cursorline = true
      -- vim.wo.relativenumber = true
      -- end
    end
  end,
})

vim.api.nvim_create_autocmd({
  "FocusLost",
  "WinLeave",
  "InsertEnter",
}, {
  callback = function(opts)
    local ft = vim.bo[opts.buf].filetype
    local bt = vim.bo[opts.buf].buftype
    -- if not (bt == "nofile" or bt == "") then
    if bt == "" or bt == "help" then
      -- if not vim.tbl_contains(ignored_fts, ft) then
      vim.wo.cursorline = false
      -- end
    end
  end,
})
