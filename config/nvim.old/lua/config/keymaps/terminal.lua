-- floating terminal
map("n", "<leader>ft", function() Util.float_term(nil, { cwd = Util.get_root() }) end, "terminal (root dir)")
map("n", "<leader>fT", function() Util.float_term() end, "terminal (cwd)")

map("t", "<esc>", "<C-\\><C-n>", "enter normal mode")
map("t", "<M-right>", [[<M-f>]])
map("t", "<M-left>", [[<M-b>]])
map("t", "<C-h>", [[<cmd>wincmd h<cr>]])
map("t", "<C-j>", [[<cmd>wincmd j<cr>]])
map("t", "<C-k>", [[<cmd>wincmd k<cr>]])
map("t", "<C-l>", [[<cmd>wincmd l<cr>]])
