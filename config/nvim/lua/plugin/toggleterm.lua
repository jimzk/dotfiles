require("toggleterm").setup {
  open_mapping = [[<M-space>]],
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  direction = "float", -- 'vertical' | 'horizontal' | 'tab' | 'float'
  float_opts = {
    winblend = 20,
    width = 100,
    border = 'single', -- 'single' | 'double' | 'shadow' | 'curved'
  },
  on_open = function(_)
    vim.keymap.set("n", "<esc>", ":q<cr>", { buffer = true, silent = true })
  end
}
-- TODO: integrate lazygit
-- https://github.com/akinsho/toggleterm.nvim#custom-terminals

-- https://github.com/akinsho/toggleterm.nvim#terminal-window-mappings
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
