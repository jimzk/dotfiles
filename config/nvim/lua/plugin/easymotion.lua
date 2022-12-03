-- https://github.com/easymotion/vim-easymotion
--
-- bd: bidirectional motions, support both forward and backward.
-- overwin: over windows

-- Move to word
vim.keymap.set("", ",w", "<Plug>(easymotion-w)")
vim.keymap.set("", ",b", "<Plug>(easymotion-b)")
vim.keymap.set("", ",e", "<Plug>(easymotion-e)")
vim.keymap.set("", ",ge", "<Plug>(easymotion-ge)")

-- Move to word in current line
vim.keymap.set("", ",l", "<Plug>(easymotion-lineforward)")
vim.keymap.set("", ",h", "<Plug>(easymotion-linebackward)")

-- Move to line
vim.keymap.set("", ",j", "<Plug>(easymotion-j)")
vim.keymap.set("", ",k", "<Plug>(easymotion-k)")
vim.keymap.set("", ",g", "<Plug>(easymotion-bd-jk)")
vim.keymap.set("n", ",g", "<Plug>(easymotion-overwin-line)")


-- Search (followed by {char})
vim.keymap.set("", ",f", "<Plug>(easymotion-f)")
vim.keymap.set("", ",F", "<Plug>(easymotion-F)")
vim.keymap.set("", ",t", "<Plug>(easymotion-t)")
vim.keymap.set("", ",T", "<Plug>(easymotion-T)")
--  map <leader><leader>/ <Plug>(easymotion-sn)

-- default configs: https://github.com/easymotion/vim-easymotion/blob/master/plugin/EasyMotion.vim
vim.g.EasyMotion_space_jump_first = 1
vim.g.EasyMotion_startofline = 1 -- set 0 if you want to kepp cursor at the same column after line move
vim.g.EasyMotion_smartcase = 1 -- smart case sensitive (type `l` and match `l`&`L`)
vim.g.EasyMotion_use_smartsign_us = 1 -- Smartsign (type `3` and match `3`&`#`)
vim.g.EasyMotion_keys = 'asdghklqwertyuiopzxcvbnmfj;'
