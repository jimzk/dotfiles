vim.g.mapleader = " "

local opt = vim.opt
opt.clipboard = "unnamedplus" -- sync with system clipboard

require("config.keymaps.normal")
require("config.keymaps.text")

vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank()
  end,
})

local map = Util.map

map({ "x" }, "p", '"0p')
map({ "x" }, "P", '"0P')

local function map_vscode_action(mode, lhs, action, desc, opts)
  map(mode, lhs, string.format("<CMD>lua require('vscode-neovim').action('%s')<CR>", action), desc, opts)
end

map_vscode_action("n", "<leader>u", "git.revertSelectedRanges")
map_vscode_action({ "x", "n" }, "<leader>a", "git.stageSelectedRanges")
map_vscode_action("n", "<leader>A", "git.stage")
