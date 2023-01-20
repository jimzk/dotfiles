-- break line
map({ "n", "i" }, "<S-cr>", function()
  local pos = vim.api.nvim_win_get_cursor(0)
  local mode = vim.fn.mode()
  local cmd = mode == "n" and [[a\<cr>]] or [[i\<cr>]]
  vim.cmd([[execute "normal! ]] .. cmd .. [["]])
  vim.api.nvim_win_set_cursor(0, pos)
end, "break line")

-- Navigate in insert mode
map("i", "<C-h>", "<Left>")
map("i", "<C-l>", "<Right>")
map("i", "<C-j>", "<Down>")
map("i", "<C-k>", "<Up>")

-- Delete forward
map("i", "<C-BS>", "<right><BS>", "detele forward")

-- duplicate line
map("n", "<leader>d", [[V"vY'>"vp]], "duplicate line")
map("v", "<leader>d", [["vY'>"vp]], "duplicate line")

-- Cmdline
map({ "c", "i" }, "<C-E>", "<End>")
map({ "c", "i" }, "<C-A>", "<Home>") -- if mapting silent = true then <C-A> can't work. Don't know why.
map("c", "<C-j>", "<DOWN>")
map("c", "<C-k>", "<UP>")
map({ "c", "i" }, "<M-BS>", "<C-W>")
map({ "c", "i" }, "<S-BS>", "<C-U>")
map({ "c", "i" }, "<M-b>", "<S-Left>")
map({ "c", "i" }, "<M-f>", "<S-Right>")
map({ "c", "i" }, "<M-Left>", "<S-Left>")
map({ "c", "i" }, "<M-Right>", "<S-Right>")
