-- https://github.com/petertriho/nvim-scrollbar#setup-packer
-- setup up and overwrite hlslens
require("scrollbar.handlers.search").setup({
  -- https://github.com/kevinhwang91/nvim-hlslens#customize-virtual-text
  override_lens = function(render, posList, nearest, idx, relIdx)
    local sfw = vim.v.searchforward == 1
    local indicator, text, chunks
    local absRelIdx = math.abs(relIdx)
    if absRelIdx > 1 then
      indicator = ('%d%s'):format(absRelIdx, sfw ~= (relIdx > 1) and '▲' or '▼')
    elseif absRelIdx == 1 then
      indicator = sfw ~= (relIdx == 1) and '▲' or '▼'
    else
      indicator = ''
    end

    local lnum, col = unpack(posList[idx])
    if nearest then
      local cnt = #posList
      if indicator ~= '' then
        text = ('[%s %d/%d]'):format(indicator, idx, cnt)
      else
        text = ('[%d/%d]'):format(idx, cnt)
      end
      chunks = { { ' ', 'Ignore' }, { text, 'HlSearchLensNear' } }
    else
      text = ('[%s %d]'):format(indicator, idx)
      chunks = { { ' ', 'Ignore' }, { text, 'HlSearchLens' } }
    end
    render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
  end,
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
