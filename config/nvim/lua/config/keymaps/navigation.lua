local map = require("util").map
local del = vim.keymap.del

-- Tabs
-- https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/config/keymaps.lua#L164
del("n", "<leader><tab>l")
del("n", "<leader><tab>f")
del("n", "<leader><tab><tab>")
del("n", "<leader><tab>]")
del("n", "<leader><tab>d")
del("n", "<leader><tab>[")

map("n", "<C-->", "<cmd>tabp<cr>", "Prev Tab")
map("n", "<C-=>", "<cmd>tabn<cr>", "Next Tab")
map("n", "<C-t>n", "<Cmd>tabnew<Cr>", "New Tab")
map("n", "<C-t>N", "<Cmd>tabedit %<Cr>", "New Tab (Break Out)")
map("n", "<C-t>d", "<cmd>tabclose<cr>", "Close Tab")
map("n", "<C-t>o", "<cmd>tabonly<cr>", "Close Other Tabs")
-- map("n", "<C-t>t", "g<Tab>", "Go to Last Visited Tab (<M-t>)")
map("n", "<M-t>", "g<Tab>", "Go to Last Visited Tab")
for char = string.byte("a"), string.byte("z") do
  local letter = string.char(char)
  local fromMapping = "<c-t><c-" .. letter .. ">"
  local toMapping = "<c-t>" .. letter
  map("n", fromMapping, toMapping, nil, { remap = true })
end

-- Buffers
del("n", "[b")
del("n", "]b")
-- map("n", "<space><space>", "<C-^>", "Go Alternative Buffer")
-- map("n", "<space><c-space>", "<cmd>vs #<cr>", "Split Alternative Buffer")
-- map("n", "<leader>`", "<C-^>", "Go Alternative Buffer")
-- map("n", "<leader>~", "<cmd>vs #<cr>", "Split Alternative Buffer")
del("n", "<leader>`")
del("n", "<leader>bb")
-- map("n", "<C-b>b", "<C-^>", "Go Alternative Buffer (<M-b>)")
-- map("n", "<C-b>B", "<cmd>vs #<cr>", "Split Alternative Buffer (<M-S-b>)")
map("n", "<M-b>", "<C-^>", "Go Alternative Buffer")
map("n", "<M-S-b>", "<cmd>vs #<cr>", "Split Alternative Buffer")
map("n", "<C-b>n", "<cmd>vnew<cr>", "New Buffer")
for char = string.byte("a"), string.byte("z") do
  local letter = string.char(char)
  local fromMapping = "<c-b><c-" .. letter .. ">"
  local toMapping = "<c-b>" .. letter
  map("n", fromMapping, toMapping, nil, { remap = true })
end

-- Windows
-- https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/config/keymaps.lua#L156
del("n", "<leader>ww")
del("n", "<leader>wd")
del("n", "<leader>w-")
del("n", "<leader>w|")
del("n", "<leader>-")
del("n", "<leader>|")
map("n", "<C-w>n", "<CMD>vnew<CR>", "New Window")
map("n", "<C-w>N", "<CMD>new<CR>", "New Window Vertically")
map("n", "<M-w>", "<CMD>wincmd p<CR>", "Alternative Window")

-- map("n", "<leader>ww", "<C-W>p", "Othe Window", { remap = true })
-- map("n", "<leader>wd", "<C-W>c", "Delee Window", { remap = true })
-- map("n", "<leader>w-", "<C-W>s", "Split Window Below", { remap = true })
-- map("n", "<leader>w|", "<C-W>v", "Split Window Right", { remap = true })
-- map("n", "<leader>wt", "<C-W>T", "Extend Window Tab", { remap = true })

-- https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/config/keymaps.lua#L132
del("n", "<leader>qq")
