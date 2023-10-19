---@diagnostic disable: duplicate-set-field
local M = {}

local on_list_lua = function(opts)
  local unique = {}
  local items = {}
  for _, item in ipairs(opts.items) do
    local lnum = tostring(item.lnum)
    if not unique[lnum] then
      table.insert(items, item)
    end
    unique[lnum] = item.col
  end
  opts.items = items
  vim.fn.setqflist({}, " ", opts)
  vim.cmd [[copen]]
end

-- Remove duplicate items in the same line from lua lsp_definition result
local lsp_definition = vim.lsp.buf.definition
vim.lsp.buf.definition = function(opts)
  if vim.bo.filetype == "lua" then
    opts = opts or {}
    opts.on_list = on_list_lua
  end
  return lsp_definition(opts)
end

local lsp_references = vim.lsp.buf.references
vim.lsp.buf.references = function(context, opts)
  if vim.bo.filetype == "lua" then
    opts = opts or {}
    opts.on_list = on_list_lua
  end
  return lsp_references(context, opts)
end

M.on_attach = function(bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
  local next_diagnostics_repeat, prev_diagnostics_repeat = ts_repeat_move.make_repeatable_move_pair(
    function() vim.diagnostic.goto_next { float = true } end,
    function() vim.diagnostic.goto_prev { float = true } end)
  map("n", "]X", next_diagnostics_repeat, "[C] next diagnostic", opts)
  map("n", "[X", prev_diagnostics_repeat, "[C] prev diagnostic", opts)
  map("n", "gX", function() vim.diagnostic.open_float { focusable = true, focus = true } end,
    "[C] peek diagnostic", opts)
  map("n", "g<M-x>", function()
    vim.cmd("Trouble document_diagnostics")
    vim.notify("List diagnostics in current buffer")
  end, "[C] list diagnostics in buffer", opts)
  map("n", "g<M-S-x>", function()
    vim.cmd("Trouble workspace_diagnostics")
    vim.notify("List diagnostics in workspace")
  end, "[C] list diagnostics in workspace", opts)

  local ft = vim.bo[bufnr].filetype
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  if ft == "lua" then
    map("n", "gd", vim.lsp.buf.definition, "[C] definition", opts)
  else
    map("n", "gd", vim.lsp.buf.declaration, "[C] declaration", opts)
    map("n", "gD", vim.lsp.buf.definition, "[C] definition", opts)
  end
  map("n", "g<C-d>", "<cmd>Telescope lsp_definitions<cr>", "[C] definition list", opts)

  if ft ~= "rust" then
    map("n", "gh", function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()
      -- :h ufo.txt
      if winid then
        local buf = vim.api.nvim_win_get_buf(winid)
        local keys = { "a", "i", "o", "A", "I", "O", "gd", "gr" }
        for _, k in ipairs(keys) do
          vim.keymap.set("n", k, "<CR>" .. k, { noremap = false, buffer = buf })
        end
      else
        vim.lsp.buf.hover()
      end
    end, "[C] hover or peek fold", opts)
  end
  map("n", "gI", vim.lsp.buf.implementation, "[C] go implementation", opts)
  map("n", "gb", vim.lsp.buf.type_definition, "[C] go type definition", opts)
  map("n", "gr", vim.lsp.buf.references, "[C] go reference", opts)
  map("n", "g[", vim.lsp.buf.incoming_calls, "[C] incoming call tree", opts)
  map("n", "g]", vim.lsp.buf.outgoing_calls, "[C] outgoing call tree", opts)

  map("n", "<leader>cr", vim.lsp.buf.rename, "[C] rename", opts)
  -- map({ "n", "v" }, "<M-cr>", "<cmd>lua vim.lsp.buf.code_action()<CR>", "[C] code action", opts)
  map({ "n", "v" }, "<M-cr>", "<cmd>CodeActionMenu<CR>", "[C] code action", opts)

  map("n", "<leader>cwa", function() vim.lsp.buf.add_workspace_folder() end, "add LSP workspace folder", opts)
  map("n", "<leader>cwr", function() vim.lsp.buf.remove_workspace_folder() end, "remove LSP workspace folder", opts)
  map("n", "<leader>cwl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
    "list LSP workspace folder", opts)
  map("n", "<leader>ci", "<cmd>LspInfo<cr>", "LSP Info", opts)

  -- map({ "n", "i", "v" }, "<C-space>", vim.lsp.buf.signature_help, "[C] peek signature", opts)

  local format = require "plugins.lsp.format"
  map("n", "<F12>", format.format, "format buffer", opts)
  map("v", "<F12>", format.format, "format selection", opts)
  map("n", "<leader><F12>", format.toggle, "toggle format on save", opts)
end

return M
