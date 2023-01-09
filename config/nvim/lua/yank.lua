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
