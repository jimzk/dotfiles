-- https://github.com/petertriho/nvim-scrollbar#setup-packer
-- setup up and overwrite hlslens
require("scrollbar.handlers.search").setup({
  -- virtual text (https://github.com/kevinhwang91/nvim-hlslens#customize-virtual-text) is
  -- distracting so I dismiss all.
  override_lens = function() end
})

-- https://github.com/kevinhwang91/nvim-hlslens#minimal-configuration
local kopts = { noremap = true, silent = true }
vim.keymap.set("n", "*", [[*<cmd>lua require('hlslens').start()<cr>]], kopts)
vim.keymap.set('n', 'n', function() -- make n alwasy match forward
  local c = vim.v.searchforward == 0 and 'N' or 'n'
  local cmd = string.format([[execute('normal! ' . v:count1 . '%s')]], c)
  vim.cmd(cmd)
  require("hlslens").start()
end, kopts)
vim.keymap.set('n', 'N', function()
  local c = vim.v.searchforward == 0 and 'n' or 'N'
  local cmd = string.format([[execute('normal! ' . v:count1 . '%s')]], c)
  vim.cmd(cmd)
  require("hlslens").start()
end, kopts)

-- https://github.com/kevinhwang91/nvim-hlslens#vim-visual-multi
vim.cmd([[
aug VMlens
  au!
  au User visual_multi_start lua require('plugin.utils.vmlens').start()
  au User visual_multi_exit lua require('plugin.utils.vmlens').exit()
aug END
]])
