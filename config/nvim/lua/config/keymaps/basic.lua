-- floating terminal
map("n", "<leader>ft", function() Util.float_term(nil, { cwd = Util.get_root() }) end, "terminal (root dir)")
map("n", "<leader>fT", function() Util.float_term() end, "terminal (cwd)")

map("t", "<esc><esc>", "<C-\\><C-n>", "enter normal mode")
map("t", "<M-right>", [[<M-f>]])
map("t", "<M-left>", [[<M-b>]])

-- -- tabs
-- map("n", "<leader><tab>l", "<cmd>tablast<cr>", "Last")
-- map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", "First")
-- map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", "New Tab")
-- map("n", "<leader><tab>]", "<cmd>tabnext<cr>", "Next")
-- map("n", "<leader><tab>d", "<cmd>tabclose<cr>", "Close")
-- map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", "Previous")
