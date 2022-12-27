-- https://github.com/petertriho/nvim-scrollbar#setup-packer
-- setup up and overwrite hlslens
require("scrollbar.handlers.search").setup({
  -- virtual text (https://github.com/kevinhwang91/nvim-hlslens#customize-virtual-text) is
  -- distracting so I dismiss all.
  override_lens = function() end
})

-- Start hlslens for * n N
-- https://github.com/kevinhwang91/nvim-hlslens#minimal-configuration
-- Set global n/N function to integrat with vim-sneak.
_G.Enhanced_n = function() -- make n alwasy match forward
  local c = vim.v.searchforward == 0 and 'N' or 'n'
  -- Keep jumplist unchanged
  local cmd = string.format([[execute('keepjumps normal! ' . v:count1 . '%s')]], c)
  vim.cmd("silent! " .. cmd) -- Do not show error
  require("hlslens").start()
end
_G.Enhanced_N = function()
  local c = vim.v.searchforward == 0 and 'n' or 'N'
  local cmd = string.format([[execute('keepjumps normal! ' . v:count1 . '%s')]], c)
  vim.cmd("silent! " .. cmd)
  require("hlslens").start()
end

-- https://github.com/kevinhwang91/nvim-hlslens#vim-visual-multi
vim.cmd([[
aug VMlens
  au!
  au User visual_multi_start lua require('plugin.utils.vmlens').start()
  au User visual_multi_exit lua require('plugin.utils.vmlens').exit()
aug END
]])
