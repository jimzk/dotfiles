-- Add undo break-points
local chars = { ",", ".", ";", "/", "<space>" }
for _, char in ipairs(chars) do
  map("i", char, char .. "<C-g>u")
end

-- break line
-- map({ "n", "i" }, "<C-cr>", function()
--   local cmd = [[i\<cr>]]
--   local pos = vim.api.nvim_win_get_cursor(0)
--   vim.cmd([[execute "normal! ]] .. cmd .. [["]])
--   vim.api.nvim_win_set_cursor(0, pos)
-- end, "break line")

-- https://www.reddit.com/r/neovim/comments/10kah18/comment/j5pwppw/?utm_source=share&utm_medium=web2x&context=3
map({ "n", "i" }, "<S-cr>", "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>", "add new line above")
map({ "n", "i" }, "<C-s-cr>", "<Cmd>call append(line('.'), repeat([''], v:count1))<CR>", "add new line below")
map({ "i" }, "<M-o>", "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>", "add new line above")
map({ "i" }, "<M-S-o>", "<Cmd>call append(line('.'), repeat([''], v:count1))<CR>", "add new line below")
-- Reselect latest changed, put, or yanked text
-- From: https://github.com/echasnovski/mini.basics/blob/main/lua/mini/basics.lua#L536
-- FIX: not work
-- map("n", "gV", '"`[" . strpart(getregtype(), 0, 1) . "`]"', { expr = true, desc = "visually select changed text" })

-- Navigate in insert mode
map("i", "<M-h>", "<Left>")
map("i", "<M-l>", "<Right>")
map("i", "<M-j>", "<Down>")
map("i", "<M-k>", "<Up>")
-- Stay in insert mode
map("i", "<M-u>", "<cmd>normal! u<cr>")
map("i", "<M-S-u>", [[<cmd>exec "normal! \<C-r>"<cr>]]) -- Flaw: cursor won't be recovered
-- map("i", "<C-z>", "<cmd>normal! u<cr>")
-- map("i", "<C-S-z>", [[<cmd>exec "normal! \<C-r>"<cr>]]) -- Flaw: cursor won't be recovered

-- duplicate line (deprecated by duplicate.nvim)
-- map("n", "<leader>d", [[V"vY'>"vp]], "duplicate line")
-- map("v", "<leader>d", [["vY'>"vp]], "duplicate line")

-- <M-*> in insert mode execute * in normal
-- see https://www.reddit.com/r/neovim/comments/17uwnoe/comment/k99dozh/
-- But I change the most logic and make them stay in insert mode
local map_i = function(lhs, rhs)
  map("i", lhs, rhs)
  if type(rhs) == "string" then
    -- Only in this way many keys (e.g. C-A) can work otherwise it will be lagging. Don't know why.
    vim.cmd("cnoremap <special> " .. lhs .. " " .. rhs)
  end
end
-- :h emacs-keys*
-- map_i("<C-E>", "<END>")
-- map_i("<C-A>", "<HOME>")
-- map_i("<C-B>", "<Left>")
-- map_i("<C-F>", "<Right>")
map_i("<M-a>", Util.feedkeys("<Esc>A"))
map_i("<M-i>", Util.feedkeys("<Esc>I"))
-- Replace
map_i("<M-r>", Util.feedkeys("<Esc>lR"))   -- Replace
-- Delete
map_i("<M-x>", "<BS>")                     -- delete char
map_i("<M-S-x>", "<right><BS>")            -- delete char backwards
map_i("<C-BS>", "<right><BS>")             -- delete char backwards
map_i("<M-BS>", "<C-W>")                   -- delete word
map_i("<S-BS>", "<C-U>")                   -- delete to start
map_i("<M-d>", "<C-U>")                    -- delete to start
map_i("<M-S-d>", Util.feedkeys("<Esc>lC")) -- delete to end
map_i("<M-s>", "<BS>")                     -- delete char
map_i("<M-S-s>", Util.feedkeys("<Esc>cc")) -- delete line and move cursor to start
map_i("<M-S-BS>", Util.feedkeys("<Esc>cc"))
-- Paste
map_i("<M-p>", function() -- cursor after paste
  vim.cmd([[execute "normal! \<Plug>(YankyPutBeforeCharwiseJoined)"]])
end)
map_i("<M-S-p>", function() -- cursor before paste
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd([[execute "normal! \<Plug>(YankyPutBeforeCharwiseJoined)"]])
  vim.api.nvim_win_set_cursor(0, pos)
end)
-- Move
map_i("<M-b>", "<S-Left>")
map_i("<M-w>", "<S-Right>")
map_i("<M-Left>", "<S-Left>")
map_i("<M-Right>", "<S-Right>")
-- Indent

-- History in cmdline
vim.cmd("cnoremap <special> <M-p> <Up>")
vim.cmd("cnoremap <special> <M-n> <Down>")
