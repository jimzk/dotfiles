local map = require("util").map
local util = require("util")

-- Add undo break-points
map("i", "<M-u>", "<C-o>u", "Undo")
-- '"', "'" are taken charged by the autopair plugin
for _, char in ipairs({ ",", ".", ";", "/", "<CR>" }) do
  map("i", char, char .. "<C-g>u")
end
for _, char in ipairs({ "o", "O", "i", "I", "a", "A", "gi" }) do
  map("n", char, char .. "<C-g>u")
end

-- Smart dd: no yank empty line
-- https://www.reddit.com/r/neovim/comments/1abd2cq/comment/kjn1kww
map("n", "dd", function()
  if vim.fn.getline("."):match("^%s*$") then
    return '"_dd'
  end
  return "dd"
end, nil, { expr = true })

-- Replacement
-- * https://www.reddit.com/r/neovim/comments/1abd2cq/comment/kjojs2y
-- * https://www.reddit.com/r/neovim/comments/1abd2cq/comment/kjn1kww
map("n", "<leader>rx", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "Replace Cursor Word (Exact)")
-- & to repeat search
map(
  "n",
  "<leader>rk",
  ":s/\\(.*\\)/\\1<left><left><left><left><left><left><left><left><left>",
  "Replace in Current Line"
)
-- stylua: ignore
map( "x", "<leader>rk", ":s/\\(.*\\)/\\1<left><left><left><left><left><left><left><left><left>", "Replace in Visual Range")

map("v", "<leader>rw", '"hy:%s/<C-r>h/<C-r>h/gc<left><left><left>', "Replace")
map("n", "<leader>rw", ":%s/<C-r><C-w>/<C-r><C-w>/gcI<Left><Left><Left><Left>", "Replace Cursor Word")

-- Search in visual range
map("x", "/", "<Esc>/\\%V", "Search in the Visual")
-- Search in visible range (:h search-range)
map("n", "<leader>r/", function()
  vim.wo.scrolloff = 0
  local topline = vim.fn.winsaveview().topline
  local bottomline = vim.api.nvim_win_get_height(0) + topline
  local keys = string.format([[/\%%>%sl\%%<%sl]], topline - 1, bottomline)
  util.feedkeys(keys)()
end, "Search in Visible Area")

require("which-key").register({
  ["<leader>rs"] = { name = "replace snippets" },
})

-- https://www.reddit.com/r/neovim/comments/1ajdtvi/replacing_a_with_b_in_every_line_that_contains_c/
map("n", "<leader>rsr", ":g/C/g!/D/s/A/B/g", "Replace A by B in lines having C and not D")

-- https://www.reddit.com/r/neovim/comments/10kah18/comment/j5pwppw
-- map({ "n", "i" }, "<S-cr>", "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>", "Add New Line Above")
-- map({ "n", "i" }, "<S-cr>", "<Cmd>call append(line('.'), repeat([''], v:count1))<CR>", "Add New Line Aelow")

local in_empty_line = function()
  return vim.fn.getline("."):match("^%s*$")
end

map({ "i" }, "<S-cr>", function()
  if not in_empty_line() then
    local cursor = vim.api.nvim_win_get_cursor(0)
    cursor[2] = vim.api.nvim_get_current_line():find("$") -- tail
    vim.api.nvim_win_set_cursor(0, cursor)
  end
  require("util").feedkeys("<CR>")()
end, "Add New Line Down and Move Cursor")
-- map({ "i" }, "<S-M-cr>", function()
--   if not in_empty_line() then
--     local cursor = vim.api.nvim_win_get_cursor(0)
--     cursor[2] = (vim.api.nvim_get_current_line():find("[^%s]") or 1) - 1 -- head
--     vim.api.nvim_win_set_cursor(0, cursor)
--   end
--   require("util").feedkeys("<CR><Up>")()
-- end, "Add New Line Up and Move Cursor")

map({ "i" }, "<C-cr>", function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_win_set_cursor(0, cursor)
  require("util").feedkeys("<CR>")()
  vim.schedule(function()
    if not in_empty_line() then -- no restore position for pairs <cr>
      require("util").feedkeys("<CR>")()
      vim.api.nvim_win_set_cursor(0, cursor)
    end
  end)
end, "Break Line")

local map_i = function(lhs, rhs)
  map("i", lhs, rhs)
  if type(rhs) == "string" then
    -- Only in this way many keys (e.g. C-A) can work otherwise it will be lagging. Don't know why.
    vim.cmd("cnoremap <special> " .. lhs .. " " .. rhs)
  end
end

-- :h emacs-keys*
-- Move
map_i("<M-b>", "<S-Left>")
map_i("<M-f>", "<S-Right>")
-- map_i("<C-b>", "<S-Left>")
-- map_i("<C-f>", "<S-Right>")
map_i("<C-h>", "<Left>")
map_i("<C-j>", "<Down>")
map_i("<C-k>", "<Up>")
map_i("<C-l>", "<Right>")

map_i("<C-a>", "<HOME>")
map_i("<C-e>", "<END>")

map_i("<M-Left>", "<S-Left>")
map_i("<M-Right>", "<S-Right>")

-- Delete
-- map_i("<M-x>", "<BS>") -- delete char
-- map_i("<M-S-x>", "<right><BS>") -- delete char backwards
map_i("<C-BS>", "<right><BS>") -- delete char backwards
map_i("<M-BS>", "<C-W>") -- delete word
map_i("<S-BS>", "<C-U>") -- delete to start
-- map_i("<M-d>", "<C-U>") -- delete to start
-- map_i("<M-S-d>", Util.feedkeys("<Esc>lC")) -- delete to end
-- map_i("<M-s>", "<BS>") -- delete char
-- map_i("<M-S-s>", Util.feedkeys("<Esc>cc")) -- delete line and move cursor to start
-- map_i("<M-S-BS>", Util.feedkeys("<Esc>cc"))
