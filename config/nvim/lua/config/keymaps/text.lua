local map = Util.map
local del = vim.keymap.del

-- Add undo break-points
map("i", "<M-u>", "<C-o>u", "Undo")
-- '"', "'" are taken charged by the autopair plugin
for _, char in ipairs({ ",", ".", ";", "/" }) do
  map("i", char, char .. "<C-g>u")
end
for _, char in ipairs({ "o", "O", "i", "I", "a", "A", "gi" }) do
  map("n", char, char .. "<C-g>u")
end

local normal_cut = function()
  -- Smart cut: no yank empty line
  -- https://www.reddit.com/r/neovim/comments/1abd2cq/comment/kjn1kww
  local smart_cut_n = function(key, cmd1, cmd2)
    cmd1 = cmd1 or ('"_' .. key)
    cmd2 = cmd2 or key
    map("n", key, function()
      return vim.fn.getline("."):match("^%s*$") and cmd1 or cmd2
    end, nil, { expr = true })
  end

  map({ "n", "x" }, "d", "d")
  map({ "n", "x" }, "D", "D")
  map({ "n", "x" }, "c", "c")
  map({ "n", "x" }, "C", "C")
  smart_cut_n("dd")
  smart_cut_n("D")
  smart_cut_n("cc")
  smart_cut_n("C")
  map("x", "C", "c", nil, { remap = true })
end
normal_cut()
-- Blackhole register switch
vim.g.cut_clipboard_enabled = true
map({ "n", "x" }, "<leader><leader>", function()
  Util.toggle(function()
    return vim.g.cut_clipboard_enabled
  end, function()
    if vim.g.cut_clipboard_enabled == true then
      map({ "n", "x" }, "d", '"_d')
      map({ "n", "x" }, "D", '"_D')
      map({ "n", "x" }, "c", '"_c')
      map({ "n", "x" }, "C", '"_C')
      del({ "n" }, "dd")
      del({ "n" }, "cc")
      map("x", "C", "c", nil, { remap = true })
    else
      normal_cut()
    end
    vim.g.cut_clipboard_enabled = not vim.g.cut_clipboard_enabled
  end, "Clipboard for Cut")
end, "Toggle Clipboard")
map({ "n", "x" }, "<leader>o_", "<leader><leader>", "Toggle Clipboard", { remap = true })

-- https://www.reddit.com/r/neovim/comments/10kah18/comment/j5pwppw
map({ "n", "i" }, "<M-S-o>", "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>", "Add New Line Above")
map({ "n", "i" }, "<M-o>", "<Cmd>call append(line('.'), repeat([''], v:count1))<CR>", "Add New Line Aelow")
-- map({ "i" }, "<C-cr>", Util.feedkeys("<m-o>", "t"), "Add New Line Down and Move Cursor")
map({ "i" }, "<C-m>", function()
  vim.api.nvim_put({ "", "" }, "c", false, false)
end, "Break Line")
map({ "i" }, "<S-cr>", function()
  local last_chars = {
    rust = ";",
    lua = ",",
  }
  local current_line = vim.fn.line(".")
  local line_content = vim.fn.getline(current_line)
  local ft = vim.bo.filetype
  local last_char = last_chars[ft]
  if not line_content:match("^%s*$") and line_content:sub(-1) ~= last_char then
    line_content = line_content .. last_char
    vim.fn.setline(current_line, line_content)
  end
  Util.feedkeys("<Esc>o")()
end, "Add Colon to Line End and Move to Next New Line")

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
del("n", "L")
del("n", "H")

-- Ecmas keymappings. See:
-- - :h emacs-keys*
-- - https://github.com/tpope/vim-rsi
-- Go to beginning of line
map("i", "<C-a>", home)
vim.cmd([[cnoremap <C-A> <Home>]])
-- Go to end of line
map({ "i", "c" }, "<C-e>", "<End>")
vim.cmd([[
" Go backwards one character
inoremap <expr> <C-B> getline('.')=~'^\s*$'&&col('.')>strlen(getline('.'))?"0\<Lt>C-D>\<Lt>Esc>kJs":"\<Lt>Left>"
cnoremap        <C-B> <Left>
" Go forwards one character
inoremap <expr> <C-F> col('.')>strlen(getline('.'))?"\<Lt>C-F>":"\<Lt>Right>"
cnoremap <expr> <C-F> getcmdpos()>strlen(getcmdline())?&cedit:"\<Lt>Right>"
" Go forwards one word
noremap! <M-b> <S-Left>
noremap! <M-f> <S-Right>
noremap! <M-Left> <S-Left>
noremap! <M-Right> <S-Right>
" Delete backward one word
noremap! <M-BS> <C-W>
noremap! <M-C-h> <C-W>
" Delete forkward one Word
noremap! <C-M-BS> <C-O>dw
cnoremap <C-M-BS> <S-Right><C-W>
" Delete forwards cursor
inoremap <expr> <C-D> col('.')>strlen(getline('.'))?"\<Lt>C-D>":"\<Lt>Del>"
cnoremap <expr> <C-D> getcmdpos()>strlen(getcmdline())?"\<Lt>C-D>":"\<Lt>Del>"
" History in cmdline
cnoremap <special> <C-k> <Up>
cnoremap <special> <C-j> <Down>
]])
-- TODO:
-- map_i("<M-s>", "<Esc>d<cmd>lua require('spider').motion('b', { subwordMovement = true })<CR>i") -- delete sub word
-- map_i("<M-s>", "<space><Esc>c<cmd>lua require('spider').motion('b', { subwordMovement = true })<CR>") -- delete sub word

--  Delete to end of line. <C-u> delete to beginning of line.
map("i", "<C-k>", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = cursor[1]
  local col = cursor[2]
  local current_line = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1]
  local new_line = string.sub(current_line, 1, col)
  vim.api.nvim_buf_set_lines(bufnr, line - 1, line, false, { new_line })
end)
-- Delete whole line
map("i", "<S-BS>", function()
  local current_line = vim.api.nvim_get_current_line()
  local indent = current_line:match("^%s+$") -- empty line
      and ""
    or current_line:match("^%s*")
  vim.api.nvim_buf_set_lines(
    0,
    vim.api.nvim_win_get_cursor(0)[1] - 1,
    vim.api.nvim_win_get_cursor(0)[1],
    false,
    { indent }
  )
end)
