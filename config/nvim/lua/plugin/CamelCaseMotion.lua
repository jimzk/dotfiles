

--  https://github.com/bkad/CamelCaseMotion

vim.keymap.set("", "<leader>w", "<Plug>CamelCaseMotion_w", {silent = true})
vim.keymap.set("", "<leader>b", "<Plug>CamelCaseMotion_b", {silent = true})
vim.keymap.set("", "<leader>e", "<Plug>CamelCaseMotion_e", {silent = true})
vim.keymap.set("", "<leader>ge", "<Plug>CamelCaseMotion_ge", {silent = true})

vim.keymap.del('s', "<leader>w")
vim.keymap.del('s', "<leader>b")
vim.keymap.del('s', "<leader>e")
vim.keymap.del('s', "<leader>ge")

vim.keymap.set("o", "i<leader>w", "<Plug>CamelCaseMotion_iw", {silent = true})
vim.keymap.set("x", "i<leader>w", "<Plug>CamelCaseMotion_iw", {silent = true})
vim.keymap.set("o", "i<leader>b", "<Plug>CamelCaseMotion_ib", {silent = true})
vim.keymap.set("x", "i<leader>b", "<Plug>CamelCaseMotion_ib", {silent = true})
vim.keymap.set("o", "i<leader>e", "<Plug>CamelCaseMotion_ie", {silent = true})
vim.keymap.set("x", "i<leader>e", "<Plug>CamelCaseMotion_ie", {silent = true})
