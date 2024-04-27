local map = Util.map
local del = vim.keymap.del

-- floating terminal
local lazyterm = function()
  LazyVim.terminal(nil, { cwd = LazyVim.root() })
end

del("n", "<leader>ft")
del("n", "<leader>fT")
del("n", "<c-/>")
del("n", "<c-_>")
del("t", "<C-/>")
del("t", "<c-_>")
del("t", "<Esc><Esc>")

-- <C-\><C-n> to normal mode in terminal
map("n", "<c-\\>", lazyterm, "Terminal (Root)")
map("t", "<C-\\>", "<cmd>close<cr>", "Hide Terminal")
map("t", "<C-esc>", "<C-\\><C-n>")

if vim.g.neovide then
  map("n", "<D-\\>", lazyterm, "Terminal (Root)")
  map("t", "<D-\\>", "<cmd>close<cr>", "Hide Terminal")
  map("t", "<D-esc>", "<C-\\><C-n>")
end
