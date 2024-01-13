local lazy_util = require("lazyvim.util")
local map = vim.keymap.set
local del = vim.keymap.del

-- floating terminal
local lazyterm = function()
  lazy_util.terminal(nil, { cwd = lazy_util.root() })
end

del("n", "<leader>ft")
del("n", "<leader>fT")
del("n", "<c-/>")
del("n", "<c-_>")
del("t", "<C-/>")
del("t", "<c-_>")
del("t", "<Esc><Esc>")

-- <C-\><C-n> to normal mode in terminal
map("n", "<c-\\>", lazyterm, { desc = "Terminal (Root)" })
map("t", "<C-\\>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<C-esc>", "<C-\\><C-n>")

if vim.g.neovide then
  map("n", "<D-\\>", lazyterm, { desc = "Terminal (Root)" })
  map("t", "<D-\\>", "<cmd>close<cr>", { desc = "Hide Terminal" })
  map("t", "<D-esc>", "<C-\\><C-n>")
end
