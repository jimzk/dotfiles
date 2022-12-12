-- Fix * in visual mode alwasy reselect search word
vim.keymap.set("v", "*", [[y/\V<C-R>=escape(@",'/\')<CR><CR>]], { noremap = true })

-- No copy when paste in visual mode
vim.keymap.set("x", "p", function()
  vim.fn.setreg("v", vim.fn.getreg("+"))
  vim.cmd [[normal! p]]
  vim.fn.setreg("+", vim.fn.getreg("v"))
end, { silent = true, noremap = true })
vim.keymap.set("x", "P", function()
  vim.fn.setreg("v", vim.fn.getreg("+"))
  vim.cmd [[normal! P]]
  vim.fn.setreg("+", vim.fn.getreg("v"))
end, { silent = true, noremap = true })
