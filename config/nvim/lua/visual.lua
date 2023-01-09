-- Disable hlsearch automatically.
-- From: https://this-week-in-neovim.org/2023/Jan/09#tips
-- I previously set * stay at original position and not change jumplist:
-- set("n", "*", [[mv"vyiw/\V<C-R>=escape(@v,'/\')<CR><CR>g`v<cmd>delm v<cr>]], opts)
-- But it is invalided by the following configurtion
local ns = vim.api.nvim_create_namespace('toggle_hlsearch')
local function toggle_hlsearch(char)
  if vim.fn.mode() == 'n' then
    local keys = { '<CR>', 'n', 'N', '*', '#', '?', '/' }
    local new_hlsearch = vim.tbl_contains(keys, vim.fn.keytrans(char))
    if vim.opt.hlsearch:get() ~= new_hlsearch then
      vim.opt.hlsearch = new_hlsearch
    end
  end
end

vim.on_key(toggle_hlsearch, ns)

-- Keep cursor and window layout unchange after using * and g*
-- Replace previous keymap:
--   set("n", "*", [["vyiw/\V<C-R>=escape(@v,'/\')<CR><CR>N]], opts)
local asterisk = function(yank_keys, transfer_pattern)
  return function()
    local view = vim.fn.winsaveview()
    vim.cmd('normal! "v' .. yank_keys)
    local pattern = vim.fn.getreg("v")
        :gsub("/", [[\/]]) -- escape /
    vim.fn.setreg("v", "") -- clear register
    if transfer_pattern then
      pattern = transfer_pattern(pattern)
    end
    vim.cmd("keepjumps /" .. pattern)
    -- let cursor stay at original match
    -- I don't know why here should be n. Magic!
    vim.cmd [[keepjumps normal! n]]
    vim.fn.winrestview(view) -- restore win layout
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
