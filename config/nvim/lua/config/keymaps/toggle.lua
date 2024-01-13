local lazy_util = require("lazyvim.util")
local util = require("util")
local map = util.map
local del = vim.keymap.del

local toggle = function(option, ...)
  if lazy_util.toggle[option] then
    lazy_util.toggle[option](...)
  else
    lazy_util.toggle(option, ...)
  end
end

-- https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/config/keymaps.lua#L112C18-L112C18
-- stylua: ignore start
del("n", "<leader>ub")
del("n", "<leader>uf")
del("n", "<leader>uF")
vim.g.autoformat = true
map("n", "<leader>of", function() lazy_util.format.toggle(true) end,   "Toggle Autoformat (Buffer)" )
map("n", "<leader>oF", function() lazy_util.format.toggle() end,   "Toggle Autoformat (Global)" )
del("n", "<leader>us")
map("n", "<leader>os", function() toggle("spell") end, "Toggle Spelling" )
del("n", "<leader>uw")
map("n", "<leader>ow", function() toggle("wrap") end, "Toggle Word Wrap" )
del("n", "<leader>uL")
map("n", "<leader>oN", function() toggle("relativenumber") end, "Toggle Relative Line Numbers" )
del("n", "<leader>ul")
map("n", "<leader>on", function() toggle("number") end, "Toggle Line Numbers" )
del("n", "<leader>ud")
map("n", "<leader>od", function() toggle("diagnostics") end, "Toggle Diagnostics" )
map("n", "<leader>do", function() toggle("diagnostics") end, "Toggle Diagnostics" )
map("n", "<leader>oC", function() toggle("ignorecase") end, "Toggle Case Ignore" )
del("n", "<leader>uc")
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
map("n", "<leader>oc", function() toggle("conceallevel", false, {0, conceallevel}) end, "Toggle Conceal" )
del("n", "<leader>uh")
map("n", "<leader>oi", function()
  -- FIX: LazyVim not catch up neovim 10.0 changes in vim.lsp.inlay_hint.enable()
  toggle("inlay_hints")
  vim.cmd("NvimContextVtToggle")
end, "Toggle Inlay Hints")
-- stylua: ignore end

del("n", "<leader>uT")
map("n", "<leader>oh", function()
  require("util").toggle(
    vim.b.ts_highlight,
    { vim.treesitter.start, vim.treesitter.stop },
    "Treesitter Highlight",
    "Option"
  )
end, "Toggle Treesitter Highlight")

map("n", "<leader>oD", function()
  require("util").toggle(function()
    return vim.diagnostic.config().virtual_text
  end, function()
    vim.cmd("Corn toggle")
  end, "Inline Diagnostics", "Option")
end, "Toggle Diagnostics inline")

-- https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/config/keymaps.lua#L135C1-L136C1
del("n", "<leader>ui")
map("n", "<leader>np", vim.show_pos, "Inspect Position")

map("n", "<leader>om", function()
  local bo = vim.bo[0]
  require("util").toggle(vim.bo[0].modifiable, function()
    bo.readonly = not bo.readonly
    bo.modifiable = not bo.modifiable
  end, "File Modifiable", "Option")
end, "Toggle Modifiable")

-- https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/config/keymaps.lua#L47
del("n", "<leader>ur")
map(
  "n",
  "<leader>o<cr>",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  "Redraw / Clear hlsearch / Diff Update"
)

-- stylua: ignore start
map("n", "<leader>o<Tab>", function()
  vim.ui.input({ prompt = "Enter Indent Width: " }, function(input)
    if not input then
      return
    end
    vim.bo.tabstop = tonumber(input)
    vim.bo.shiftwidth = tonumber(input)
    vim.notify("Set Indent Width to " .. input)
  end)
end,   "Set Indent Width" )
-- stylua: ignore end
map("n", "<leader>nt", function()
  local node = vim.treesitter.get_node():type()
  -- copy(node)
  vim.notify('Treesitter node under cursor is "' .. node .. '". Name copied.')
end, "Inspect Treesitter Ndoe under Cursor")

local file_detail = function()
  local home = vim.fn.getenv("HOME")
  -- local filename = vim.fn.expand("%:p:t")
  -- local repo_root = vim.fn.system("git rev-parse --show-toplevel")
  --     :gsub(home, "~")
  --     :gsub("\n", "")
  -- local filedir = vim.fn.expand("%:p:h")
  --     :gsub(home, "~")
  --     :gsub(repo_root, "")
  local relative_file_path = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
  local msg = string.format(
    [[
Working Dir: %s
  File Path: %s
  File Type: %s
  Buffer Nr: %s
  Window Id: %s]],
    vim.fn.getcwd():gsub(home, "~"),
    "/" .. relative_file_path,
    vim.bo.filetype,
    vim.api.nvim_get_current_buf(),
    vim.api.nvim_get_current_win()
  )
  require("notify")(msg, vim.log.levels.INFO, { title = "File Info", timeout = 3000 })
end
map("n", "<leader>?", file_detail, "File Info")
map("n", "<leader>n?", "<leader>?", "File Info", { remap = true })

-- Lazy
del("n", "<leader>l")
map("n", "<leader>nz", "<cmd>Lazy<cr>", "Lazy")
map("n", "<leader>nZ", function()
  require("lazyvim.util").news.changelog()
end, "LazyVim Changelog")
