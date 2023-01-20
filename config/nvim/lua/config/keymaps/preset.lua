-- Some key are totally equal, like <Tab> and <C-i>, <Esc> and <C-[>.
-- If mapping one, the other is mapped as well.
--
-- Luckily, nvim support out-of-box solution CSI u to distinguish them.
--
-- Ref:
-- * https://alpha2phi.medium.com/neovim-101-terminal-and-shell-5be83b9f2b88
-- * https://github.com/neovim/neovim/issues/20126
-- * :h key-codes to check what keys is euivalent
--
-- To use CSIu mapping:
-- 1. Map two keys individually
-- 2. Enbable CSIu in terminal or GUI.
map("n", "<C-m>", "<Nop>") -- Need to map <Cr> as well
map("n", "<CR>", [[<cmd>silent! exec "normal \<C-]>"<cr>]])
map({ "n", "o", "v" }, "<Esc>", "<Esc>")

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", "Escape and clear hlsearch")
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", nil, { expr = true })
map({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", nil, { expr = true })

-- better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", nil, { expr = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", nil, { expr = true })

-- map("n", "<", "<<")
-- map("n", ">", ">>")
-- Avoid lost selection after indent
-- https://github.com/mhinz/vim-galore#dont-lose-selection-when-shifting-sidewards
-- map("x", ">", ">gv")
-- map("x", "<", "<gv")

-- No yank for c/C
-- map({ "n" }, "c", '"_c')
-- map({ "n" }, "C", '"_C')
