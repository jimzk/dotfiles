-- Add undo break-points
local chars = { ",", ".", ";", "/", "<space>" }
for _, char in ipairs(chars) do
  map("i", char, char .. "<C-g>u")
end

-- break line
map({ "n", "i" }, "<C-cr>", function()
  local cmd = [[i\<cr>]]
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd([[execute "normal! ]] .. cmd .. [["]])
  vim.api.nvim_win_set_cursor(0, pos)
end, "break line")

-- https://www.reddit.com/r/neovim/comments/10kah18/comment/j5pwppw/?utm_source=share&utm_medium=web2x&context=3
map({ "n", "i" }, "<S-cr>", "<Cmd>call append(line('.'), repeat([''], v:count1))<CR>", "assert new line below")

-- Reselect latest changed, put, or yanked text
-- From: https://github.com/echasnovski/mini.basics/blob/main/lua/mini/basics.lua#L536
-- FIX: not work
map("n", "gV", '"`[" . strpart(getregtype(), 0, 1) . "`]"', { expr = true, desc = "visually select changed text" })

-- Navigate in insert mode
map("i", "<C-h>", "<Left>")
map("i", "<C-l>", "<Right>")
map("i", "<C-j>", "<Down>")
map("i", "<C-k>", "<Up>")

-- duplicate line
map("n", "<leader>d", [[V"vY'>"vp]], "duplicate line")
map("v", "<leader>d", [["vY'>"vp]], "duplicate line")

-- Cmdline
-- :h emacs-keys*
map({ "c", "i" }, "<C-E>", "<END>")
map({ "i" }, "<C-A>", "<HOME>")
-- Only in this way C-A can work otherwise there will be lagging. Don't know why.
vim.cmd([[cnoremap <special> <C-A> <HOME>]])

map({ "c", "i" }, "<C-B>", "<Left>")
map({ "c", "i" }, "<C-F>", "<Right>")

-- map("c", "<C-J>", "<DOWN>")
-- map("c", "<C-K>", "<UP>")

-- Delete
map({ "c", "i" }, "<M-BS>", "<C-W>") -- delete word
map({ "c", "i" }, "<S-BS>", "<C-U>") -- delete to start
map({ "c", "i" }, "<C-BS>", "<right><BS>") -- delete back

-- Move
map({ "c", "i" }, "<M-b>", "<S-Left>")
map({ "c", "i" }, "<M-f>", "<S-Right>")
map({ "c", "i" }, "<M-Left>", "<S-Left>")
map({ "c", "i" }, "<M-Right>", "<S-Right>")
