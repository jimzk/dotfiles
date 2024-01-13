local map = require("util").map
local del = vim.keymap.del

-- To use CSIu mapping:
-- 1. Map two keys individually
-- 2. Enbable CSIu in terminal or GUI.
-- map("n", "<C-m>", "<Nop>") -- Need to map <Cr> as well
map({ "n", "o", "x" }, "<Esc>", "<Esc>")
map({ "n", "o", "x" }, "<C-i>", "<C-i>")

-- map("n", "q", function()
--   local current_bufnr = vim.api.nvim_get_current_buf()
--   local current_winnr = vim.api.nvim_get_current_win()
--   local has_others_listed = false
--   for _, winnr in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
--     local bufnr = vim.fn.winbufnr(winnr)
--     local listed = vim.bo[bufnr].buflisted
--     if (bufnr ~= current_bufnr or winnr ~= current_winnr) and listed then
--       has_others_listed = true
--     end
--   end
--   if has_others_listed then
--     vim.cmd("close")
--   else
--     require("notify")("Cannot close last window", vim.log.levels.WARN, { title = "Close" })
--   end
-- end)
map("n", "q", "<CMD>close<CR>")
-- map("n", "<C-q>", "<CMD>silent! bufdo up<CR><CMD>qa<cr>")
map("n", "<C-q>", "<CMD>qa<cr>")
map("n", "U", "<C-r>", "Redo")

map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr>", "Save File")

-- Scroll
-- map("n", "<Up>", "<C-y>")
-- map("n", "<Down>", "<C-e>")
-- map("n", "<C-d>", "<C-d>zz")
-- map("n", "<C-u>", "<C-u>zz")
-- map("n", "}", "}zz")
-- map("n", "{", "{zz")

-- Press key twice to jump fist blank char of link
-- https://luyuhuang.tech/2023/03/21/nvim.html#跳转到行开头
local function home()
  local head = (vim.api.nvim_get_current_line():find("[^%s]") or 1) - 1
  local cursor = vim.api.nvim_win_get_cursor(0)
  cursor[2] = cursor[2] == head and 0 or head
  vim.api.nvim_win_set_cursor(0, cursor)
end
map({ "n", "x", "o" }, "<Home>", home)
map({ "n", "x", "o" }, "0", home)
-- map({ "n", "x", "o" }, "0", home)
-- map({ "n", "x", "o" }, "0", function()
--   local _, y = unpack(vim.api.nvim_win_get_cursor(0))
--   vim.cmd("normal! m`")
--   if y == 0 then
--     vim.cmd("normal! H")
--   else
--     home()
--   end
-- end)
-- map({ "n", "x", "o" }, "$", function()
--   local _, y = unpack(vim.api.nvim_win_get_cursor(0))
--   local line_len = #vim.api.nvim_get_current_line()
--   vim.cmd("normal! m`")
--   if y + 1 >= line_len then
--     vim.cmd("normal! L")
--   else
--     vim.cmd("normal! $")
--   end
-- end)
del("n", "L")
del("n", "H")

-- https://www.reddit.com/r/neovim/comments/1abd2cq/comment/kjn1kww
map("x", ".", ":norm .<CR>", "Repeat in Selection")
map("x", "@", ":norm @q<CR>", "Execute Macro in Selection")

map(
  "n",
  "<C-Cr>",
  [[<cmd>silent! exec "normal! \<C-]>zz"<cr><cmd>lua require("lualine").refresh()<cr>]],
  "Jump to Definition"
)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
-- map({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", nil, { expr = true })
-- map({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", nil, { expr = true })
local nN = function(forward)
  local direction = forward and { "N", "n" } or { "n", "N" }
  local char = direction[vim.v.searchforward + 1] -- lua table index starts from 1
  -- Integrate with hlslens and ufo, support jumping to folded text
  -- https://github.com/kevinhwang91/nvim-hlslens#nvim-ufo
  local ok, winid = require("hlslens").nNPeekWithUFO(char)
  if ok and winid then
    -- Type <CR> will switch to preview window and fire `trace` action
    vim.keymap.set("n", "<CR>", function()
      local keyCodes = vim.api.nvim_replace_termcodes("<Tab><CR>", true, false, true)
      vim.api.nvim_feedkeys(keyCodes, "im", false)
    end, { buffer = true })
  end
  -- Keep jumplist unchanged
  -- local cmd = string.format([[execute('keepjumps normal! ' . v:count1 . '%s')]], char)
  -- vim.cmd("silent! " .. cmd) -- suppress error "pattern not found"
  -- require("hlslens").start()
end
-- stylua: ignore start
map({ "n", "x", "o" }, "n", function() nN(true) end)
map({ "n", "x", "o" }, "N", function() nN(false) end)
-- stylua: ignore end

-- Avoid lost visual selection
map("x", "~", "~gv")
map("x", "u", "ugv")
map("x", "U", "Ugv")

map({ "n", "x" }, "X", '"_d')
map({ "n" }, "XX", '"_dd')

-- blackhole register: cut without copying to register
-- map({ "n", "x" }, "<leader>xd", '"_d', "Blackhole d")
-- map({ "n" }, "<leader>xdd", '"_dd')
-- map({ "n", "x" }, "<leader>xD", '"_D', "Blackhole D")
--
-- map({ "n", "x" }, "<leader>xc", '"_c', "Blackhole c")
-- map({ "n" }, "<leader>xcc", '"_cc')
-- map({ "n", "x" }, "<leader>xC", '"_C', "Blackhole C")
