vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'fugitiveblame' },
  callback = function()
    vim.keymap.set("n", "?", "<cmd>help :Git_blame<cr>", { buffer = true, silent = true })
  end
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'fugitive' },
  callback = function()
    vim.keymap.set("n", "?", "<cmd>help fugitive-map<cr>", { buffer = true, silent = true })
  end
})
