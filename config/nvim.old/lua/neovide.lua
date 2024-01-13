-- https://neovide.dev/configuration.html
if not vim.g.neovide then return end

vim.g.neovide_remember_window_size = true
vim.g.neovide_input_macos_alt_is_meta = true
vim.g.neovide_input_use_logo = true

-- https://github.com/neovide/neovide/issues/270#issuecomment-1221006358
-- Copy paste
map("x", "<D-x>", "x")
map("n", "<D-c>", "y")
map("n", "<D-v>", "gP")
map({ "i" }, "<D-v>", "<C-R>+")
vim.cmd [[cnoremap <special> <D-v> <C-R>+]]
map("x", "<D-v>", "<Plug>(YankyPutAfterCharwise)")
-- Move
map({ "i" }, "<D-right>", "<END>")
map({ "i" }, "<D-left>", "<HOME>")
vim.cmd [[cnoremap <special> <D-right> <END>]]
vim.cmd [[cnoremap <special> <D-left> <HOME>]]
-- Undo / redo
map("n", "<D-z>", "u")
map("i", "<D-z>", "<cmd>normal! u<cr>")
map("n", "<D-S-z>", "<C-r>")
map("i", "<D-S-z>", [[<Esc><C-r>a]])
-- Save
map({ "i", "x", "n" }, "<D-s>", "<cmd>up<cr>")
-- New tab
map({ "i", "x", "n" }, "<D-t>", "<cmd>tabnew<cr>")
-- Fullscreen
map({ "i", "x", "n" }, "<C-D-f>", "<cmd>let g:neovide_fullscreen = 1 - g:neovide_fullscreen<cr>")
map({ "i", "x", "n" }, "<D-cr>", "<cmd>let g:neovide_fullscreen = 1 - g:neovide_fullscreen<cr>")
-- Break line
map({ "n", "i" }, "<D-cr>", function()
  local cmd = [[i\<cr>]]
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd([[execute "normal! ]] .. cmd .. [["]])
  vim.api.nvim_win_set_cursor(0, pos)
end)
-- Delete to start
map({ "i" }, "<D-BS>", "<C-u>", nil, { noremap = false })
-- Duplicate lines
map("n", "<D-d>", [[V"vY'>"vp]])
map("v", "<D-d>", [["vY'>"vp]])

local notify_opts = { title = "Neovide" }
vim.g.guifont_size = 13
vim.o.guifont = "FiraCode Nerd Font Mono" .. ":h" .. vim.g.guifont_size

-- local change_font_size = function(delta)
--   vim.g.guifont_size = vim.g.guifont_size + delta
--   vim.o.guifont = string.gmatch(vim.o.guifont, ".*:")() .. "h" .. vim.g.guifont_size
--   vim.notify("Font size: " .. vim.g.guifont_size, vim.log.levels.INFO, notify_opts)
-- end
-- vim.keymap.set("n", "<D-->", function()
--   change_font_size(-0.5)
-- end, { silent = true, noremap = true, desc = "decrease font size" })
-- vim.keymap.set("n", "<D-=>", function()
--   change_font_size(0.5)
-- end, { silent = true, noremap = true, desc = "increase font size" })

-- https://neovide.dev/faq.html#how-can-i-dynamically-change-the-scale-at-runtime
vim.g.neovide_scale_factor = 1.0
local change_scale_factor = function(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end
map("n", "<D-]>", function() change_scale_factor(1.05) end, "increase font scale")
map("n", "<D-[>", function() change_scale_factor(1 / 1.05) end, "decrease font scale")
map("n", "<D-=>", function() vim.g.neovide_scale_factor = 1.0 end, "revert font scale")

-- https://neovide.dev/faq.html#how-can-i-dynamically-change-the-transparency-at-runtime-macos
vim.g.neovide_transparency = 0.99
-- map("n", "<D-\\>", function()
--   vim.ui.input(
--     { prompt = "Current transparency is " .. vim.g.neovide_transparency .. ", input a new value: " },
--     function(input)
--       if not input then return end
--       if type(input) ~= "number" then
--         vim.notify("Input should be a number", vim.log.levels.ERROR, notify_opts)
--         return
--       end
--       vim.g.neovide_transparency = tonumber(input)
--     end
--   )
-- end, "Neovide: change transparency")
vim.g.neovide_transparency_point = 1
local change_transparency = function(delta)
  vim.notify.dismiss()
  local transparency = vim.g.neovide_transparency + delta
  if transparency < 0 then transparency = 0 end
  if transparency > 1 then transparency = 1 end
  vim.g.neovide_transparency = transparency
  vim.notify("Transparency: " .. transparency, vim.log.levels.INFO, notify_opts)
end
map("n", "<D-=>", function() change_transparency(0.025) end, "increase transparency")
map("n", "<D-->", function() change_transparency(-0.025) end, "decrease transparency")
