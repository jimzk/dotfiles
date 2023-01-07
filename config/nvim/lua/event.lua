-- For fzf and toggleterm
-- If you only want these mappings for toggle term use term://*toggleterm#* instead
vim.api.nvim_create_autocmd('TermOpen', {
  pattern = "term://*",
  callback = function()
    local opts = { buffer = true }
    set('t', '<esc>', [[<cmd>q<cr>]], opts)
    set('n', '<esc>', [[<cmd>q<cr>]], opts)
    set('t', '<M-right>', [[<M-f>]], opts)
    set('t', '<M-left>', [[<M-b>]], opts)
    set("t", "<Esc>", "<cmd>q<cr>", opts)
    set('t', '<C-i>', [[<C-\><C-n>]], opts)
    set('t', '<Tab>', [[<Tab>]], opts)
  end,
})

vim.api.nvim_create_autocmd('TermEnter', {
  pattern = "term://*",
  callback = function()
    vim.wo.signcolumn = 'no'
  end,
})

-- Clean useless marks
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    for i = 0, 10, 1 do
      vim.cmd("delm" .. tostring(i))
    end
  end,
})
