-- https://neovide.dev/configuration.html
if not vim.g.neovide then
  return
end

vim.g.guifont_size = 16
vim.o.guifont = "MonaspiceNe Nerd Font" .. ":h" .. vim.g.guifont_size

vim.g.neovide_remember_window_size = true
vim.g.neovide_input_macos_option_key_is_meta = "only_left"
vim.g.neovide_input_use_logo = true

local map = Util.map

-- https://github.com/neovide/neovide/issues/270#issuecomment-1221006358
-- Copy paste
-- map("x", "<D-x>", "x")
map("x", "<D-c>", "y")
map("n", "<D-v>", "gP")
map({ "i" }, "<D-v>", "<C-R>+")
vim.cmd([[cnoremap <special> <D-v> <C-R>+]])
map("x", "<D-v>", "<Plug>(YankyPutAfterCharwise)")
-- Move
map({ "i" }, "<D-right>", "<END>")
map({ "i" }, "<D-left>", "<HOME>")
vim.cmd([[cnoremap <special> <D-right> <END>]])
vim.cmd([[cnoremap <special> <D-left> <HOME>]])
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

-- Break line
map({ "i" }, "<D-CR>", function()
  vim.api.nvim_put({ "", "" }, "c", false, false)
end, "Break Line")

-- Delete to start
map({ "i" }, "<D-BS>", "<C-u>", nil, { noremap = false })
-- Duplicate lines
map("n", "<D-d>", [[V"vY'>"vp]])
map("v", "<D-d>", [["vY'>"vp]])

-- https://neovide.dev/faq.html#how-can-i-dynamically-change-the-scale-at-runtime
local change_scale_factor = function(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end
map("n", "<D-=>", function()
  change_scale_factor(1.05)
end, "Increase Font Scale")
map("n", "<D-->", function()
  change_scale_factor(1 / 1.05)
end, "Decrease Font Scale")
map("n", "<D-0>", function()
  vim.g.neovide_scale_factor = 1.0
end, "Revert Font Scale")

-- https://neovide.dev/faq.html#how-can-i-dynamically-change-the-transparency-at-runtime-macos
vim.g.neovide_window_blurred = true
vim.g.neovide_transparency = 0.98
vim.g.neovide_transparency_point = 1
local change_transparency = function(delta)
  require("notify").dismiss({ silent = true, pending = false })
  local transparency = vim.g.neovide_transparency + delta
  if transparency < 0 then
    transparency = 0
  end
  if transparency > 1 then
    transparency = 1
  end
  vim.g.neovide_transparency = transparency
  vim.notify("Transparency: " .. transparency, vim.log.levels.INFO, { title = "Neovide" })
end
map("n", "<D-]>", function()
  change_transparency(0.025)
end, "Increase Transparency")
map("n", "<D-[>", function()
  change_transparency(-0.025)
end, "Decrease Transparency")

map({ "n", "t" }, "<D-\\>", "<C-\\>", "Toggle Terminal", { remap = true })
