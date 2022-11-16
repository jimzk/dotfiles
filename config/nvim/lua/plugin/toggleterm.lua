require("toggleterm").setup {
  open_mapping = [[<M-j>]],
  insert_mappings = true,  -- whether or not the open mapping applies in insert mode
  direction = "float",  -- 'vertical' | 'horizontal' | 'tab' | 'float'
}
-- TODO: integrate lazygit
-- https://github.com/akinsho/toggleterm.nvim#custom-terminals

-- https://github.com/akinsho/toggleterm.nvim#terminal-window-mappings
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-w><C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-w><C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-w><C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-w><C-l>', [[<Cmd>wincmd l<CR>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
