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
      init_selection = '<CR>',
      node_incremental = '<CR>',
      node_decremental = '<BS>',
      scope_incremental = '<TAB>'
    }
  },
  -- visual regision and press = to format (gg=G`` can format all file)
  -- indent = {
  --   enable = true
  -- },
}

-- Fold by treesitter
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
vim.wo.foldenable = false -- No fold by default
