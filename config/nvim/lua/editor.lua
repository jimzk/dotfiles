vim.o.jumpoptions = 'stack' -- Make jumplist behave like web browser back / forward
vim.o.incsearch = false
-- Don't add 'resize', it will disorder restored session.
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winpos,winsize,terminal"
vim.o.clipboard = "unnamed"

-------------------------------
-- local filetypes = { "Trouble", "quifkfix", "help" }
-- for _, value in ipairs(filetypes) do
--   filetypes[value] = true
-- end
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = "*",
  callback = function()
    -- if filetypes[vim.bo.filetype] then
    --   vim.wo.cursorline = true
    -- end
  end
})
vim.api.nvim_create_autocmd('BufLeave', {
  pattern = "*",
  callback = function()
    vim.cmd [[delm v]] -- Not preserve visual start point
    vim.g.last_accessed_buf = vim.api.nvim_get_current_buf()
  end
})

-- Make visual highlight more clear
-- vim.cmd [[au ColorScheme * hi! link Visual Search]]
-- vim.cmd [[au ColorScheme * hi! Visual gui=reverse]]
vim.cmd [[au ColorScheme * hi! link Visual @text.warning]]

-------------------------------
--------- Mapping ----------
local opts = { noremap = true }

vim.g.mapleader = " "
set("n", "<Space>", "<Nop>", opts)

set("n", "U", "<C-r>", opts)
set("n", "Y", "y$", opts)

-- Move to wrapped line
set("n", "j", "gj", opts)
set("n", "k", "gk", opts)
set("n", "0", "g0", opts)
set("n", "$", "g$", opts)
set("n", "^", "g^", opts)
-- Allow arrow key in insert mode ([,]) and normal mode (<,>) and hl in normal mode wrap move
vim.opt.whichwrap:append("[,],<,>,h,l")

set("n", "<", "<<", opts)
set("n", ">", ">>", opts)
-- Avoid lost selection after indent
-- https://github.com/mhinz/vim-galore#dont-lose-selection-when-shifting-sidewards
set("x", ">", ">gv", opts)
set("x", "<", "<gv", opts)

-- Native * starting from normal mode deteches word boundary.
-- For example, * under foo can't match foo_bar.
-- I don't like this. Reverse * with g*
set("n", "*", [[mv"vyiw/\V<C-R>=escape(@v,'/\')<CR><CR>g`v<cmd>delm v<cr>]], opts) -- g`` to stay at current selection
set("n", "g*", [[mv"vyiw/\V\<<C-R>=escape(@v,'/\')<CR>\><CR>g`v<cmd>delm v<cr>]], opts)
-- Native * yank selection and can't escape /. Fix it.
-- See: https://github.com/neovim/neovim/pull/18538/files
set("v", "*", [["vymv/\V<C-R>=escape(@v,'/\')<CR><CR>g`v<cmd>delm v<cr>]], opts)
set("v", "g*", [["vymv/\V\<<C-R>=escape(@v,'/\')<CR>\><CR>g`v<cmd>delm v<cr>]], opts)

-- Get back to original poistion from visual mode
set('n', 'v', 'mvv', opts)
set('n', 'V', 'mvV', opts)
set('n', '<C-V>', 'mv<C-V>', opts)
set('n', 'gv', 'mvgv', opts)  -- FIX: break location remember for treesitter incremental_selection
-- In visual mode, <Esc> jumps back, <Cr> stays
-- set('x', '<Esc>', "<Esc>`y", opts)
set("x", "<Cr>", "<Esc>", opts) -- vmap <Cr> in sneak.lua

-- Easy jump to mark
set("n", "<Tab>", "``")

-- Cmdline
set({ "c", "i" }, "<C-E>", "<End>", opts)
set({ "c", "i" }, "<C-A>", "<Home>", opts) -- if setting silent = true then <C-A> can't work. Don't know why.
set("c", "<C-j>", "<DOWN>", opts)
set("c", "<C-k>", "<UP>", opts)
set({ "c", "i" }, "<M-BS>", "<C-W>", opts)
set({ "c", "i" }, "<S-BS>", "<C-U>", opts)
set({ "c", "i" }, "<M-b>", "<S-Left>", opts)
set({ "c", "i" }, "<M-f>", "<S-Right>", opts)
set({ "c", "i" }, "<M-Left>", "<S-Left>", opts)
set({ "c", "i" }, "<M-Right>", "<S-Right>", opts)
-- set("i", "<M-Left>", "<Esc>Bi", opts)
-- set("i", "<M-Right>", "<Esc>EWi", opts)

local co = function()
  local reg = "v"
  local pos = vim.api.nvim_buf_get_mark(0, reg)
  if pos[1] ~= 0 then
    vim.notify("jump to visual")
    vim.api.nvim_win_set_cursor(0, pos)
    vim.api.nvim_buf_set_mark(0, reg, 0, 0, {})
    return
  end
  vim.cmd [[exec "normal! \<C-o>"]]
end
set("n", "<C-o>", co, opts)
set("n", "<C-i>", "<C-i>", opts)
set("n", "-", co, opts)
set("n", "=", "<C-i>", opts)

local visual_p = function()
  vim.cmd [[normal! "vy]]
  local start_row = vim.fn.line("'<")
  local start_col = vim.fn.col("'<")
  local end_row = vim.fn.line("'>")
  -- Handle v$ or V
  local selected_end_line = vim.api.nvim_buf_get_lines(0, end_row - 1, end_row, true)[1]
  local end_col = math.min(vim.fn.col("'>"), #selected_end_line)
  -- Remove ending \n
  local pasted = vim.fn.getreg("+")
      :gsub("\n$", "") -- remove line break
  -- split by "\n"
  local replacement = {}
  for str in string.gmatch(pasted, "([^\n]+)") do
    table.insert(replacement, str)
  end
  vim.api.nvim_buf_set_text(0, start_row - 1, start_col - 1, end_row - 1, end_col, replacement)
end
set("x", "p", visual_p, opts)
set("x", "P", visual_p, opts)

-- https://vi.stackexchange.com/questions/4493/what-is-the-order-of-winenter-bufenter-bufread-syntax-filetype-events
-- Example: vim.cmd [[autocmd BufEnter * lua vim.notify('foo bar')]]
-- Easy quit
-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = { "help", "git", "gitcommit", "quickfix", "fugitive", "fugitiveblame", "symbols-outline", "nvim-dap-ui",
--     "lspsagaoutline", "qf", "spectre_panel", "Trouble", "calltree", 'checkhealth' },
--   callback = function()
--     set("n", "q", function()
--       vim.cmd [[q]]
--       if vim.bo.filetype == "NvimTree" then -- not jump back to nvim-tree
--         vim.cmd [[wincmd p]]
--       end
--     end, { buffer = true, silent = true })
--   end
-- })

-- Jump to last visited place when entering a bufer
-- https://this-week-in-neovim.org/2023/Jan/02#tips
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
