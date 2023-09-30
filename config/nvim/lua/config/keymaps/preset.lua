-- Some key are totally equal, like <Tab> and <C-i>, <Esc> and <C-[>.
-- If mapping one, the other is mapped as well.
--
-- Luckily, nvim support out-of-box solution CSI u to distinguish them.
--
-- Ref:
-- * https://alpha2phi.medium.com/neovim-101-terminal-and-shell-5be83b9f2b88
-- * https://github.com/neovim/neovim/issues/20126
-- * :h key-codes to check what keys is euivalent
--
-- To use CSIu mapping:
-- 1. Map two keys individually
-- 2. Enbable CSIu in terminal or GUI.
-- map("n", "<C-m>", "<Nop>") -- Need to map <Cr> as well
map("n", "<C-b>", [[<cmd>silent! exec "normal! \<C-]>"<cr>]])
map({ "n", "o", "x" }, "<Esc>", "<Esc>")

-- Clear hlsearch with <esc>
map({ "n" }, "<esc>", "<cmd>noh<cr><esc>")
-- Remap ' for exact postion jump
map({ "n", "x", "o" }, "'", "`")

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
map({ "n", "x", "o" }, "n", function() nN(true) end)
map({ "n", "x", "o" }, "N", function() nN(false) end)

map("n", "<C-E>", "<C-E>j")
map("n", "<C-Y>", "<C-Y>k")

map("n", "}", "}zz")
map("n", "{", "{zz")

-- Mark originaol position when combining lines
-- map("n", "J", "m`Jg``")

-- better up/down
map({ "n", "x", "o" }, "j", "v:count == 0 ? 'gj' : 'j'", nil, { expr = true })
map({ "n", "x", "o" }, "k", "v:count == 0 ? 'gk' : 'k'", nil, { expr = true })

-- Avoid lost visual selection
for _, key in pairs({ "~", "u", "U" }) do
  map("x", key, "<cmd>setlocal nocursorline<cr>" .. key .. "gv<cmd>setlocal cursorline<cr>")
end

-- map("n", "<", "<<")
-- map("n", ">", ">>")
-- Avoid lost selection after indent
-- https://github.com/mhinz/vim-galore#dont-lose-selection-when-shifting-sidewards
-- map("x", ">", ">gv")
-- map("x", "<", "<gv")
