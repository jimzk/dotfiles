vim.g["sneak#use_ic_scs"] = 1 -- Case sensitive
vim.g["sneak#absolute_dir"] = 1 -- Absolution search direction
vim.g["sneak#s_next"] = 0 -- Disable default f/F move to next after search

local opts = { noremap = true, silent = true, expr = true, replace_keycodes = false }
set({ "n", "x", "o" }, "f", [[sneak#is_sneaking() ? '<Plug>Sneak_;' : '<Plug>Sneak_s']], opts)
set({ "n", "x", "o" }, "F", [[sneak#is_sneaking() ? '<Plug>Sneak_,' : '<Plug>Sneak_S']], opts)
-- set("o", "f", [[sneak#is_sneaking() ? '<Plug>Sneak_;' : '<Plug>Sneak_t']], opts)
-- set("o", "F", [[sneak#is_sneaking() ? '<Plug>Sneak_,' : '<Plug>Sneak_T']], opts)
-- set({ "n", "x" }, "t", [[sneak#is_sneaking() ? '<Plug>Sneak_;' : '<Plug>Sneak_t']], opts)
-- set({ "n", "x" }, "T", [[sneak#is_sneaking() ? '<Plug>Sneak_,' : '<Plug>Sneak_T']], opts)
-- set({ "n", "x" }, "s", [[sneak#is_sneaking() ? '<Plug>Sneak_;' : '<Plug>Sneak_s']], opts)
-- set({ "n", "x" }, "S", [[sneak#is_sneaking() ? '<Plug>Sneak_,' : '<Plug>Sneak_S']], opts)

set("", "n", [[sneak#is_sneaking() ? '<Plug>Sneak_;' : '<cmd>lua Enhanced_n()<cr>']], opts)
set("", "N", [[sneak#is_sneaking() ? '<Plug>Sneak_,' : '<cmd>lua Enhanced_N()<cr>']], opts)

set("n", "<Esc>", [[sneak#is_sneaking() ? ':<C-u>call sneak#cancel()<cr>' : '<Esc><cmd>noh<cr>']], opts)
-- set("n", "<Esc>", function()
--   if vim.fn["sneak#is_sneaking"]() == 1 then
--     vim.fn["sneak#cancel"]()
--   elseif vim.v.hlsearch == 1 then
--     vim.cmd [[noh]]
--   else
--     pcall(vim.cmd, [[normal ``]])
--   end
-- end)
-- Below equals above
-- set("n", "<Esc>", [[sneak#is_sneaking() ? ':<C-u>call sneak#cancel()<cr>' : v:hlsearch ? '<cmd>noh<cr>' : '``']], opts)
