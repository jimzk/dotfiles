local wk = require("which-key")
local M = {}
-- LSP keymapping
-- tweak by lspsaga (https://github.com/glepnir/lspsaga.nvim#configuration)
-- under lspconfig (https://github.com/neovim/nvim-lspconfig#suggested-configuration)
M.setup = function(bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  wk.register({
    ['[x'] = { function() vim.diagnostic.goto_prev { float = true } end, "[C] prev diagnostic" },
    [']x'] = { function() vim.diagnostic.goto_next { float = true } end, "[C] next diagnostic" },
  }, bufopts)

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  wk.register({
    g = {
      x = { function() vim.diagnostic.open_float { height = 10, width = 60 } end, "[C] peek diagnostic in current line" },
      X = { function()
        vim.cmd("Trouble document_diagnostics")
      end, "[C] list all diagnostics in buffer" },
      ["<C-x>"] = { function()
        vim.cmd("Trouble workspace_diagnostics")
      end, "[C] list all diagnostics in workspace" },
      -- ['<space> = {function() vim.diagnostic.setloclist() end, "show diagnostics in location list"},
      D = { function() vim.lsp.buf.declaration() end, "[C] declaration" },
      d = { function() vim.lsp.buf.definition() end, "[C] definition" },
      -- D = { "<cmd>normal m`<cr><cmd>Trouble lsp_definitions<cr>", "[C] go definition" },
      h = { function()
        local winid = require('ufo').peekFoldedLinesUnderCursor()
        if not winid then vim.lsp.buf.hover() end
      end, "[C] hover or peek fold" },
      -- I = { "<cmd>normal m`<cr><cmd>Trouble lsp_implementations<cr>", "[C] go implementation" },
      -- b = { "<cmd>normal m`<cr><cmd>Trouble lsp_type_definitions<cr>", "[C] go type definition" },
      -- R = { "<cmd>normal m`<cr><cmd>Trouble lsp_references<cr>", "[C] go reference" },
      I = { vim.lsp.buf.implementation, "[C] go implementation" },
      b = { vim.lsp.buf.type_definition, "[C] go type definition" },
      r = { vim.lsp.buf.references, "[C] go reference" },
      -- FIX: can't jump to file in incoming / outgoing calls in quickfix
      ["["] = { vim.lsp.buf.incoming_calls, "[C] incoming call tree" },
      ["]"] = { vim.lsp.buf.outgoing_calls, "[C] outgoing call tree" },
    },

    ['<leader>e'] = {
      w = {
        name = "lsp workspace",
        a = { function() vim.lsp.buf.add_workspace_folder() end, "add workspace folder" },
        r = { function() vim.lsp.buf.remove_workspace_folder() end, "remove workspace folder" },
        l = { function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "list workspace folder" },
      },
    },
    ["<leader>c"] = {
      r = { vim.lsp.buf.rename, "rename" },
    },
    ["<M-cr>"] = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "code action" },
  }, bufopts)

  vim.keymap.set({ "n", "i", "v" }, "<C-space>", vim.lsp.buf.signature_help,
    vim.tbl_extend("force", bufopts, { desc = "[C] peek signature" }))
end

return M
