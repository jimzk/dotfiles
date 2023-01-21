-- Add undo break-points
local chars = { ",", ".", ";", "/", "(" }
for _, char in ipairs(chars) do
  map("i", char, char .. "<C-g>u")
end

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
-- :h emacs-keys*
map({ "c", "i" }, "<C-E>", "<END>")
-- Only in this way C-A can work otherwise there will be lagging. Don't know why.
vim.cmd([[cnoremap <special> <C-A> <HOME>]])

map({ "c", "i" }, "<C-B>", "<Left>")
map({ "c", "i" }, "<C-F>", "<Right>")

-- map("c", "<C-J>", "<DOWN>")
-- map("c", "<C-K>", "<UP>")

map({ "c", "i" }, "<M-BS>", "<C-W>")
map({ "c", "i" }, "<S-BS>", "<C-U>")
map({ "c", "i" }, "<M-b>", "<S-Left>")
map({ "c", "i" }, "<M-f>", "<S-Right>")
map({ "c", "i" }, "<M-Left>", "<S-Left>")
map({ "c", "i" }, "<M-Right>", "<S-Right>")
