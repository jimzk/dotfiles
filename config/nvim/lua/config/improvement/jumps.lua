-- Get back to original poistion from visual mode
map("n", "v", "mvv")
map("n", "V", "mvV")
map("n", "<C-V>", "mv<C-V>")
-- Use ` to compatible with treesitter incremental_selection which marks v continusouly
map("n", "gv", "m`gv")

vim.api.nvim_create_autocmd("BufLeave", {
  pattern = "*",
  callback = function()
    -- No preserve visual start point
    vim.api.nvim_buf_del_mark(0, "v")
  end,
})

-- local co = function()
--   local reg = "v"
--   local pos = vim.api.nvim_buf_get_mark(0, reg)
--   if pos[1] ~= 0 then
--     local line_count = vim.api.nvim_buf_line_count(0)
--     if pos[1] <= line_count then
--       vim.api.nvim_win_set_cursor(0, pos)
--       vim.api.nvim_buf_del_mark(0, reg)
--     end
--     return
--   end
--   vim.cmd([[exec "normal! \<C-o>"]])
-- end
-- map("n", "<C-o>", co)
map("n", "<C-i>", "<C-i>")
-- map("n", "<S-Tab>", "<C-o>")
-- Modern terminal emulators (e.g. Alacritty, Kitty, iTerm) can disguise <Tab> from <C-i>, but not in TMUX
-- map("n", "<Tab>", "<C-i>")

-- Update jumplist for [cound]j/k
for i = 1, 99, 1 do
  map("n", tostring(i))
  local cmds = { "k", "j" }
  for _, cmd in ipairs(cmds) do
    cmd = i .. cmd
    map("n", cmd, "m`" .. cmd)
  end
end
