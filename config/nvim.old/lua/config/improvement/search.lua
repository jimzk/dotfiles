-- Disable hlsearch automatically.
-- From: https://this-week-in-neovim.org/2023/Jan/09#tips
-- I previously set * stay at original position and not change jumplist:
-- map("n", "*", [[mv"vyiw/\V<C-R>=escape(@v,'/\')<CR><CR>g`v<cmd>delm v<cr>]])
-- But it is invalided by the following configurtion
local ns = vim.api.nvim_create_namespace("toggle_hlsearch")
local function toggle_hlsearch(char)
  if vim.fn.mode() == "n" then
    local keys = { "<CR>", "<Esc>" }
    local should_noh = vim.tbl_contains(keys, vim.fn.keytrans(char))
    if vim.o.hlsearch and should_noh then
      vim.cmd [[noh]]
    end
  end
end

vim.on_key(toggle_hlsearch, ns)

-- Keep cursor and window layout unchange after using * and g*
-- Replace previous keymap:
--   map("n", "*", [["vyiw/\V<C-R>=escape(@v,'/\')<CR><CR>N]])
local asterisk = function(yank_keys, transfer_pattern)
  return function()
    vim.cmd('normal! "v' .. yank_keys)
    local view = vim.fn.winsaveview()
    local pattern = vim.fn.getreg("v")
        :gsub("\n$", "")            -- remove last \n
        :gsub("([/*\\%]])", "\\%1") -- escape / * \ ]
        :gsub("\n", [[\n]])
    vim.fn.setreg("v", "")          -- clear register
    if transfer_pattern then
      pattern = transfer_pattern(pattern)
    end
    vim.cmd("keepjumps /" .. pattern)
    vim.fn.winrestview(view)
    require("hlslens").start()
  end
end

map("n", "*", asterisk("yiw"))
map("v", "*", asterisk("y"))

-- map("n", "gw", asterisk("yiw"), "search (*)")
-- map("v", "gw", asterisk("y"), "search (*)")

-- I reverse original syntax of * and g*
local border_match = function(pattern) return [[\<]] .. pattern .. [[\>]] end
map("n", "g*", asterisk("yiw", border_match), "search by border")
map("v", "g*", asterisk("y", border_match), "search by border")

-- Search in visual range
-- map("x", "/", function()
--   local keys = "<Esc>/\\%V"
--   keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
--   vim.api.nvim_feedkeys(keys, "m", true)
-- end, "search in visual range")
-- Search in visible range (:h search-range)
map("n", "<C-/>", function()
  vim.wo.scrolloff = 0
  local topline = vim.fn.winsaveview().topline
  local bottomline = vim.api.nvim_win_get_height(0) + topline
  local keys = string.format([[/\%%>%sl\%%<%sl]], topline - 1, bottomline)
  Util.feedkeys(keys)()
end, "search in visible range")

-- List search result in telescope
map({ "n", "v" }, "<C-*>", function()
  local selected = Util.get_selected()
  require("telescope.builtin").grep_string({
    word_match = selected,
    prompt_title = string.format([[Search "%s" In Current Buffer]], selected),
    search_dirs = { vim.fn.expand("%") },
  })
end, "show * in telescope")
