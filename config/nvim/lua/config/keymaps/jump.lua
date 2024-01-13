local map = vim.keymap.set

-- Get back to original poistion from visual mode
map("n", "v", "m`v")
map("n", "vv", "m`v$o")
map("n", "V", "m`V")
map("n", "<C-V>", "m`<C-V>")
-- Use ` to compatible with treesitter incremental_selection which marks v continusouly
map("n", "gv", "m`gv")

-- vim.api.nvim_create_autocmd("BufLeave", {
--   pattern = "*",
--   callback = function()
--     -- No preserve visual start point
--     vim.api.nvim_buf_del_mark(0, "v")
--   end,
-- })

-- Update jumplist for [cound]j/k
-- for i = 1, 99, 1 do
--   local j_fn, k_fn = require("util").make_repeatable_move_pair(function()
--     vim.cmd("normal! m`" .. i .. "j")
--   end, function()
--     vim.cmd("normal! m`" .. i .. "k")
--   end)
--   map("n", i .. "j", j_fn)
--   map("n", i .. "k", k_fn)
-- end
