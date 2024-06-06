vim.g.mapleader = " "

local opt = vim.opt
opt.clipboard = "unnamedplus" -- sync with system clipboard

vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank()
  end,
})

local map = Util.map
local function map_vscode_action(mode, lhs, action, desc, opts)
  map(mode, lhs, string.format("<CMD>lua require('vscode-neovim').action('%s')<CR>", action), desc, opts)
end
map("n", "U", "<C-r>", "Redo")
-- Avoid lost visual selection
map("x", "~", "~gv")
map("x", "u", "ugv")
map("x", "U", "Ugv")

map({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", nil, { expr = true })
map({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", nil, { expr = true })
map({ "x" }, "p", '"0p')
map({ "x" }, "P", '"0P')

map_vscode_action("n", "<C-h>", "workbench.action.focusLeftGroup")
map_vscode_action("n", "<C-j>", "workbench.action.focusBelowGroup")
map_vscode_action("n", "<C-k>", "workbench.action.focusAboveGroup")
map_vscode_action("n", "<C-l>", "workbench.action.focusRightGroup")
map_vscode_action("n", "q", "workbench.action.closeActiveEditor")

map_vscode_action("n", "<leader>u", "git.revertSelectedRanges")
map_vscode_action({ "x", "n" }, "<leader>a", "git.stageSelectedRanges")
map_vscode_action("n", "<leader>A", "git.stage")
map_vscode_action("n", "(", "workbench.action.editor.previousChange")
map_vscode_action("n", ")", "workbench.action.editor.nextChange")
