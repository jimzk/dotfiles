require("nvim-treesitter.configs").setup {
  ensure_installed = "all",
  sync_install = false,
  auto_install = true,
  ignore_install = {}, -- Ignored parsers to ignore installing
  highlight = {
    enable = true,
    disable = { "gitcommit" }, -- No highlight for these file types
    additional_vim_regex_highlighting = false, -- No highlight by :h syntax and tree-sitter together
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = false,
      node_incremental = '<C-CR>',
      node_decremental = '<C-BS>',
      scope_incremental = false, -- '<TAB>'
    }
  },
  -- visual regision and press = to format (gg=G`` can format all file)
  -- indent = {
  --   enable = true
  -- },
}

-- Set init_selection by manual for position mark
vim.keymap.set('n', '<C-CR>', function()
  vim.cmd [[normal! mv]] -- init range selection
  require('nvim-treesitter.incremental_selection').init_selection()
end, { silent = true })

-- Fold by treesitter
-- vim.wo.foldmethod = 'expr'
-- vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
-- vim.wo.foldenable = false -- No fold by default

-- vim.o.foldcolumn = '1'
-- vim.o.foldlevel = 99
-- vim.o.foldlevelstart = 99
