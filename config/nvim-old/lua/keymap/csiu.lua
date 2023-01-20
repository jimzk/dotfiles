-- Some key are totally equal, like <Tab> and <C-i>, <Esc> and <C-[>.
-- If mapping one, the other is mapped as well.
--
-- Luckily, nvim support out-of-box solution CSI u to distinguish them.
--
-- Ref:
-- * https://alpha2phi.medium.com/neovim-101-terminal-and-shell-5be83b9f2b88
-- * https://github.com/neovim/neovim/issues/20126
-- * :h key-codes to check what keys is euivalent

-- To use CSIu mapping:
-- 1. Map two keys individually
local opts = { noremap = true }
vim.keymap.set("n", "<C-m>", "<Nop>", opts) -- Need to map <Cr> as well
set("n", "<CR>", "<C-]>", opts)

-- 2. Enbable CSIu in your terminal or GUI. Most of them support CSIu, like iTerm2 and neovide.
