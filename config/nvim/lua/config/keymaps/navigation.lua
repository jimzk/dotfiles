local map = Util.map
local del = vim.keymap.del

-- Tabs
-- https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/config/keymaps.lua#L164
del("n", "<leader><tab>l")
del("n", "<leader><tab>f")
del("n", "<leader><tab><tab>")
del("n", "<leader><tab>]")
del("n", "<leader><tab>d")
del("n", "<leader><tab>[")

local remap_ctrl_key = function(prefix)
  for char = string.byte("a"), string.byte("z") do
    local letter = string.char(char)
    local fromMapping = string.format("<c-%s><c-%s>", prefix, letter)
    local toMapping = string.format("<c-%s>%s", prefix, letter)
    map("n", fromMapping, toMapping, nil, { remap = true })
  end
end

map("n", "<C-->", "<cmd>tabp<cr>", "Prev Tab")
map("n", "<C-=>", "<cmd>tabn<cr>", "Next Tab")
map("n", "<c-t>n", "<Cmd>tabnew<Cr>", "New Tab")
map("n", "<c-t>N", "<Cmd>tabedit %<Cr>", "New Tab (Break Out)")
map("n", "<c-t>d", "<cmd>tabclose<cr>", "Close Tab")
map("n", "<c-t>o", "<cmd>tabonly<cr>", "Close Other Tabs")
map("n", "<C-t>t", "g<Tab>", "Go to Last Visited Tab (<M-t>)")
-- map("n", "<M-t>", "g<Tab>", "Go to Last Visited Tab")
remap_ctrl_key("t")

-- Buffers
del("n", "[b")
del("n", "]b")
del("n", "<leader>`")
del("n", "<leader>bb")
map("n", "<C-b>", "<C-^>", "Go Alternative Buffer")

remap_ctrl_key("r")

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
map("n", "<C-w>w", "<CMD>wincmd p<CR>", "Alternative Window")
map("n", "<C-w><C-w>", "<CMD>wincmd p<CR>", nil, { remap = true })
map("n", "<C-w>V", "<cmd>vs #<cr>", "Split Alternative Buffer")
map("n", "<C-w>S", "<cmd>sp #<cr>", "Split Alternative Buffer (Vertical)")

-- map("n", "<leader>ww", "<C-W>p", "Othe Window", { remap = true })
-- map("n", "<leader>wd", "<C-W>c", "Delee Window", { remap = true })
-- map("n", "<leader>w-", "<C-W>s", "Split Window Below", { remap = true })
-- map("n", "<leader>w|", "<C-W>v", "Split Window Right", { remap = true })
-- map("n", "<leader>wt", "<C-W>T", "Extend Window Tab", { remap = true })

-- https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/config/keymaps.lua#L132
del("n", "<leader>qq")
-- Lazygit
del("n", "<leader>gg")
del("n", "<leader>gG")
