-- Disable hlsearch automatically.
-- From: https://this-week-in-neovim.org/2023/Jan/09#tips
-- I previously set * stay at original position and not change jumplist:
-- set("n", "*", [[mv"vyiw/\V<C-R>=escape(@v,'/\')<CR><CR>g`v<cmd>delm v<cr>]], opts)
-- But it is invalided by the following configurtion
local ns = vim.api.nvim_create_namespace('toggle_hlsearch')
local function toggle_hlsearch(char)
  if vim.fn.mode() == 'n' then
    local keys = { '<CR>', '<Esc>', 'j', 'k' }
    local should_noh = vim.tbl_contains(keys, vim.fn.keytrans(char))
    if vim.o.hlsearch and should_noh then
      vim.cmd [[noh]]
    end
  end
end

vim.on_key(toggle_hlsearch, ns)

-- Keep cursor and window layout unchange after using * and g*
-- Replace previous keymap:
--   set("n", "*", [["vyiw/\V<C-R>=escape(@v,'/\')<CR><CR>N]], opts)
local asterisk = function(yank_keys, transfer_pattern)
  return function()
    vim.cmd('normal! "v' .. yank_keys)
    local view = vim.fn.winsaveview()
    local pattern = vim.fn.getreg("v")
        :gsub("\n", [[\n]])
        :gsub("\\", [[\\]])
        :gsub("/", [[\/]]) -- escape
    vim.fn.setreg("v", "") -- clear register
    if transfer_pattern then
      pattern = transfer_pattern(pattern)
    end
    vim.cmd("keepjumps /" .. pattern)
    vim.fn.winrestview(view)
  end
end
local opts = { noremap = true }
set("n", "*", asterisk('yiw'), opts)
set("v", "*", asterisk('y'), opts)
-- I reverse original syntax of * and g*
local border_match = function(pattern) return [[\<]] .. pattern .. [[\>]] end
set("n", "g*", asterisk('yiw', border_match), opts)
set("v", "g*", asterisk('y', border_match), opts)

-- Support search in visual range
set('x', '/', '<Esc>/\\%V', opts)
