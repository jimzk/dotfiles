return function()
  -- Detail of cmp_nvim_lsp capabilities: https://github.com/hrsh7th/cmp-nvim-lsp/blob/main/lua/cmp_nvim_lsp/init.lua#L37
  local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- Fold provider used by ufo (https://github.com/kevinhwang91/nvim-ufo#minimal-configuration)
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
  return {
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
    handlers = {
      -- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#borders
      -- See :h lsp-handlers
      ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" }),
      ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" }),
    },
    on_attach = function(client, bufnr)
      -- Disable highlight from lsp
      -- client.server_capabilities.semanticTokensProvider = {}
      -- Enable completion triggered by <c-x><c-o>
      vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    end,
  }
end
