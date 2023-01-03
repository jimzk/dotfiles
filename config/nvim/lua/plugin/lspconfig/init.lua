require("mason").setup()
require("mason-lspconfig").setup()

local settings = require("plugin.lspconfig.settings")
require("mason-lspconfig").setup({
  ensure_installed = (function() -- Automatically install LSP servers
    local servers = {}
    for k, _ in pairs(settings) do
      table.insert(servers, k)
    end
    return servers
  end)()
})

vim.diagnostic.config({
  virtual_text = { spacing = 2, prefix = '●' },
  float = { border = 'single', source = 'if_many' },  -- float window
  signs = false,
  update_in_insert = false,
})

local lsp_status = require("lsp-status")
lsp_status.config {
  diagnostics = false,  -- No show diagnostics
}
lsp_status.register_progress()
local make_config = function()
    -- Detail of cmp_nvim_lsp capabilities: https://github.com/hrsh7th/cmp-nvim-lsp/blob/main/lua/cmp_nvim_lsp/init.lua#L37
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  capabilities = vim.tbl_extend('keep', capabilities or {}, lsp_status.capabilities)

  return {
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
    handlers = {
      -- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#borders
      -- See :h lsp-handlers
      ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'single'}),
      ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {border = 'single'}),
    },
    on_attach = function(client, bufnr)
      -- Enable completion triggered by <c-x><c-o>
      vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
      require("plugin.lspconfig.keymap").setup(bufnr)
      -- Code context used by lualine. Better than lspsaga.
      require('nvim-navic').attach(client, bufnr)
      -- Lsp status used by lualine
      lsp_status.on_attach(client)

      -- Some configuration examples
      -- https://github.com/seblj/dotfiles/blob/master/nvim/lua/config/lspconfig/
      -- -> Show method signature when typing, format before writing, action buble
    end,
  }
end

local setup_servers = function()
  for server, _ in pairs(settings) do
    local config = make_config()
    -- Set user settings for each server
    if settings[server] then
      for k, v in pairs(settings[server]) do
          config[k] = v
      end
    end
    require('lspconfig')[server].setup(config)
  end
end

setup_servers()

require("plugin.lspconfig.lspsaga")
