local M = {}

M.on_attach = function(bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  map("n", "[x", function() vim.diagnostic.goto_prev { float = true } end, "[C] prev diagnostic", opts)
  map("n", "]x", function() vim.diagnostic.goto_next { float = true } end, "[C] next diagnostic", opts)
  map("n", "gx", function() vim.diagnostic.open_float { height = 10, width = 60 } end, "[C] peek diagnostic", opts)
  map("n", "gX", "<cmd>Trouble document_diagnostics<cr>", "[C] list diagnostics in buffer", opts)
  map("n", "g<C-x>", "<cmd>Trouble workspace_diagnostics<cr>", "[C] list diagnostics in workspace", opts)

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  map("n", "gd", vim.lsp.buf.definition, "[C] definition", opts)
  -- map("n", "gD", vim.lsp.buf.declaration, "[C] declaration", opts)
  map("n", "gD", "<cmd>Telescope lsp_definitions<cr>", "[C] definition list", opts)
  map("n", "gh", function()
    local winid = require('ufo').peekFoldedLinesUnderCursor()
    if not winid then vim.lsp.buf.hover() end
  end, "[C] hover or peek fold", opts)
  map("n", "gI", vim.lsp.buf.implementation, "[C] go implementation", opts)
  map("n", "gb", vim.lsp.buf.type_definition, "[C] go type definition", opts)
  map("n", "gr", vim.lsp.buf.references, "[C] go reference", opts)
  map("n", "g[", vim.lsp.buf.incoming_calls, "[C] incoming call tree", opts)
  map("n", "g]", vim.lsp.buf.outgoing_calls, "[C] outgoing call tree", opts)

  map("n", "<leader>cr", vim.lsp.buf.rename, "[C] rename", opts)
  map({ "n", "v" }, "<M-cr>", "<cmd>lua vim.lsp.buf.code_action()<CR>", "[C] code action", opts)

  map("n", "<leader>cwa", function() vim.lsp.buf.add_workspace_folder() end, "add LSP workspace folder", opts)
  map("n", "<leader>cwr", function() vim.lsp.buf.remove_workspace_folder() end, "remove LSP workspace folder", opts)
  map("n", "<leader>cwl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
    "list LSP workspace folder", opts)
  map("n", "<leader>ci", "<cmd>LspInfo<cr>", "LSP Info", opts)

  map({ "n", "i", "v" }, "<C-space>", vim.lsp.buf.signature_help, "[C] peek signature", opts)

  local format = require("plugins.lsp.format")
  map("n", "<leader>cl", format.format, "format buffer", opts)
  map("v", "<leader>cl", format.format, "format selection", opts)
  map("v", "<leader>cL", format.toggle, "toggle format", opts)
end

return M
