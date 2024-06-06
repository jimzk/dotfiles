local map = Util.map
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
-- map("n", "q", "<CMD>close<CR>")
-- map("n", "<C-q>", "<CMD>silent! bufdo up<CR><CMD>qa<cr>")
map("n", "<C-q>", "<CMD>qa<cr>")
map("n", "U", "<C-r>", "Redo")

map("i", "<C-s>", "<cmd>w<cr>", "Save File")

-- Scroll
-- map("n", "<Up>", "<C-y>")
-- map("n", "<Down>", "<C-e>")
-- map("n", "<C-d>", "<C-d>zz")
-- map("n", "<C-u>", "<C-u>zz")
-- map("n", "}", "}zz")
-- map("n", "{", "{zz")

-- https://www.reddit.com/r/neovim/comments/1abd2cq/comment/kjn1kww
map("x", ".", ":norm .<CR>", "Repeat in Selection")
map("x", "@", ":norm @q<CR>", "Execute Macro in Selection")

-- Tips: <C-]> and <C-LeftMouse> jump to definition
--       <C-[> and <C-RightMouse> jump back
map("n", "<C-]>", [[<cmd>silent! exec "normal! \<C-]>"<cr>]], "Jump to Tag")
map("n", "<C-[>", [[<cmd>silent! exec "normal! \<C-t>"<cr>]], "Jump Back")

-- map("n", "<C-LeftMouse>", "<LeftMouse><C-]>", "Jump to Definition", { remap = true })
-- map("n", "<C-RightMouse>", [[<cmd>silent! exec "normal! \<C-t>"<cr>]], "Jump Back")
local definition_or_tag = function()
  local can_jump_definition = false
  local bufnr = vim.api.nvim_get_current_buf()
  local attached_clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(attached_clients) do
    if client.name ~= "copilot" then
      if client.capabilities.textDocument.definition then
        -- vim.notify(client.name, vim.log.levels.INFO, { title = "Notification" })
        can_jump_definition = true
        break
      end
    end
  end

  if can_jump_definition then
    return "<LeftMouse>:lua vim.lsp.buf.definition()<CR>"
  else
    return "<LeftMouse><C-]>"
  end
end
map("n", "<C-LeftMouse>", definition_or_tag, "Jump to Definition", { remap = true, expr = true })
map("n", "<C-RightMouse>", "<C-o>", "Older History")

-- map("n", "<C-ScrollWheelDown>", "<C-o>", "Older History")
-- map("n", "<C-ScrollWheelUp>", "<C-i>", "Newer History")

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

-- See :h cmdline-window (invoke by :<C-f>, q:, q?, q/)
-- Fix conflict with my <CR> and <C-c> mapping
map("t", "<C-f>", "<C-f><CR>:set filetype=vim<CR>", "cmdline-window")
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "vim" },
  callback = function(opts)
    local bufnr = opts.buf
    local filepath = opts.file
    map("n", "<CR>", "<CR>", "Execute Command", { buffer = bufnr })
    map("n", "<C-c>", "<C-c><End>", "Edite Command in Command Line", { buffer = bufnr })
  end,
})
