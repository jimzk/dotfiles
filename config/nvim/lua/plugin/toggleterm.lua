require("toggleterm").setup {
  open_mapping = [[<M-space>]],
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  direction = "horizontal", -- 'vertical' | 'horizontal' | 'tab' | 'float'
  shade_terminals = true, -- Background color
  size = function(term)
    if term.direction == "horizontal" then
      return 20
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  float_opts = {
    winblend = 20,
    width = 140,
    border = 'single', -- 'single' | 'double' | 'shadow' | 'curved'
  },
}

-- https://github.com/akinsho/toggleterm.nvim#terminal-window-mappings
vim.api.nvim_create_autocmd('TermOpen', {
  pattern = "term://*toggleterm#*",
  callback = function()
    local opts = { buffer = true }
    set('t', '<Tab>', [[<cmd>wincmd p<cr>]], opts)
    set('t', '<M-space>', [[<cmd>ToggleTerm<cr>]], opts)
    set('n', '<BS>', [[<Nop>]], opts)
    set('n', '<C-o>', [[<Nop>]], opts)
    set('n', '<C-i>', [[<Nop>]], opts)
  end,
})
-- TODO: integrate lazygit
-- https://github.com/akinsho/toggleterm.nvim#custom-terminals

-- TODO: copy / paste with toggle terminal
-- ref: https://github.com/akinsho/toggleterm.nvim/pull/339
