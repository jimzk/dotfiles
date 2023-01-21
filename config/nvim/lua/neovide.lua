-- https://neovide.dev/configuration.html
if not vim.g.neovide then return end

vim.g.neovide_remember_window_size = true
vim.g.neovide_input_macos_alt_is_meta = true
vim.g.neovide_input_use_logo = true
-- https://github.com/neovide/neovide/issues/270#issuecomment-1221006358
vim.cmd [[
vnoremap <special> <D-x> "+x
vnoremap <special> <D-c> "+y
nnoremap <special> <D-v> "+gP
inoremap <special> <D-v> <C-R>+

execute 'vnoremap <script> <special> <D-v>' paste#paste_cmd['v']
execute 'inoremap <script> <special> <D-v>' paste#paste_cmd['i']
nnoremap <special> <silent> <D-t> <cmd>tabnew<cr>
inoremap <special> <silent> <D-s> <cmd>x<cr>
vnoremap <special> <silent> <D-s> <cmd>x<cr>
nnoremap <special> <silent> <D-s> <cmd>x<cr>

nnoremap <special> <C-D-f> <cmd>let g:neovide_fullscreen = 1 - g:neovide_fullscreen<cr>
nnoremap <special> <D-Cr> <cmd>let g:neovide_fullscreen = 1 - g:neovide_fullscreen<cr>

"cnoremap <special> <D-c> <C-Y>
cnoremap <special> <D-v> <C-R>+
cnoremap <special> <D-left> <HOME>
cnoremap <special> <D-right> <END>
]]

local notify_opts = { title = "Neovide" }
vim.g.guifont_size = 12
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
local change_scale_factor = function(delta) vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta end
vim.keymap.set("n", "<D-]>", function() change_scale_factor(1.05) end, { desc = "increase font scale" })
vim.keymap.set("n", "<D-[>", function() change_scale_factor(1 / 1.05) end, { desc = "decrease font scale" })
vim.keymap.set("n", "<D-=>", function() vim.g.neovide_scale_factor = 1.0 end, { desc = "revert font scale" })

-- https://neovide.dev/faq.html#how-can-i-dynamically-change-the-transparency-at-runtime-macos
vim.g.neovide_transparency = 0.95
-- vim.g.neovide_transparency_point = 1
-- -- vim.g.neovide_background_color = "#192330" .. string.format("%x", 255 * vim.g.neovide_transparency_point)
-- local change_transparency = function(delta)
--   vim.g.neovide_transparency_point = vim.g.neovide_transparency_point + delta
--   vim.g.neovide_background_color = "#192330" .. string.format("%x", 255 * vim.g.neovide_transparency_point)
--   if math.ceil(vim.g.neovide_transparency_point * 100) % 5 == 0 then
--     vim.notify("Transparency: " .. vim.g.neovide_transparency_point, vim.log.levels.INFO, notify_opts)
--   end
-- end
-- vim.keymap.set("n", "<D-,>", function()
--   change_transparency(-0.01)
-- end, { desc = "decrease transparency" })
-- vim.keymap.set("n", "<D-.>", function()
--   change_transparency(0.01)
-- end, { desc = "increase transparency" })
