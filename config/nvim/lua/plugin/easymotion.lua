-- https://github.com/easymotion/vim-easymotion
--
-- bd: bidirectional motions, support both forward and backward.
-- overwin: over windows

-- Move to word
vim.keymap.set("", "<leader><leader>w", "<Plug>(easymotion-w)")
vim.keymap.set("", "<leader><leader>b", "<Plug>(easymotion-b)")
vim.keymap.set("", "<leader><leader>e", "<Plug>(easymotion-e)")
vim.keymap.set("", "<leader><leader>ge", "<Plug>(easymotion-ge)")

-- Move to word in current line
vim.keymap.set("", "<leader><leader>l", "<Plug>(easymotion-lineforward)")
vim.keymap.set("", "<leader><leader>h", "<Plug>(easymotion-linebackward)")

-- Move to line
vim.keymap.set("", "<leader><leader>j", "<Plug>(easymotion-j)")
vim.keymap.set("", "<leader><leader>k", "<Plug>(easymotion-k)")
vim.keymap.set("", "<leader><leader>g", "<Plug>(easymotion-bd-jk)")
vim.keymap.set("n", "<leader><leader>g", "<Plug>(easymotion-overwin-line)")


-- Search (followed by {char})
vim.keymap.set("", "<leader><leader>f", "<Plug>(easymotion-f)")
vim.keymap.set("", "<leader><leader>F", "<Plug>(easymotion-F)")
vim.keymap.set("", "<leader><leader>t", "<Plug>(easymotion-t)")
vim.keymap.set("", "<leader><leader>T", "<Plug>(easymotion-T)")
--  map <leader><leader>/ <Plug>(easymotion-sn)

-- default configs: https://github.com/easymotion/vim-easymotion/blob/master/plugin/EasyMotion.vim
vim.g.EasyMotion_space_jump_first = 1
vim.g.EasyMotion_startofline = 1 -- set 0 if you want to kepp cursor at the same column after line move
vim.g.EasyMotion_smartcase = 1 -- smart case sensitive (type `l` and match `l`&`L`)
vim.g.EasyMotion_use_smartsign_us = 1 -- Smartsign (type `3` and match `3`&`#`)
vim.g.EasyMotion_keys = 'asdghklqwertyuiopzxcvbnmfj;'
