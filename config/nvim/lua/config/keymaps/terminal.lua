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

del("t", "<C-h>")
del("t", "<C-j>")
del("t", "<C-k>")
del("t", "<C-l>")
del("t", "<C-/>")
del("t", "<c-_>")
del("t", "<Esc><Esc>")

-- <C-\><C-n> to normal mode in terminal
-- map("n", "<C-\\>", lazyterm, "Terminal (Root)")
-- map("t", "<C-\\>", function()
--   vim.cmd("close")
--   vim.wo.cursorline = true
-- end, "Hide Terminal")
map("t", "<C-esc>", "<C-\\><C-n>")
