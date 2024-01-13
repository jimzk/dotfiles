-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local packages = {
  "normal",
  "toggle",
  "navigation",
  "file",
  "text",
  "terminal",
  "jump",
}
for _, p in ipairs(packages) do
  require("config.keymaps." .. p)
end

local map = vim.keymap.set
local del = vim.keymap.del

del("n", "<leader>K")

-- Remap diagnostic
-- https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/config/keymaps.lua#L94-L108
local map_diagnostic = function(key, severity)
  local next_diagnostic = function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity[severity] })
  end
  local prev_diagnostic = function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity[severity] })
  end
  local go_next_proxy, go_prev_proxy = require("util").make_repeatable_move_pair(next_diagnostic, prev_diagnostic)
  local severity_desc = severity and " (" .. severity .. ") " or ""
  map("n", "]" .. key, go_next_proxy, { desc = "Next Diagnostic" .. severity_desc })
  map("n", "[" .. key, go_prev_proxy, { desc = "Prev Diagnostic" .. severity_desc })
end
map_diagnostic("D")
map_diagnostic("d", "ERROR")
-- map("n", "<leader>dl", "]d", { desc = "Next Diagnostic ERROR (]d)", remap = true })
-- map("n", "<leader>dh", "[d", { desc = "Prev Diagnostic ERROR ([d)", remap = true })
-- map("n", "<leader>dL", "]D", { desc = "Next Diagnostic (]D)", remap = true })
-- map("n", "<leader>dH", "[D", { desc = "Prev Diagnostic ([D)", remap = true })
del("n", "[e")
del("n", "]e")
del("n", "[w")
del("n", "]w")

del("n", "<leader>xl")
del("n", "<leader>xq")

-- map_diagnostic("e", "ERROR")
-- map_diagnostic("w", "WARN")
del("n", "<leader>cd")
map("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Peek Diagnostics" })
