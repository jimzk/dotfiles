require("mason").setup()
require("mason-lspconfig").setup()

vim.diagnostic.config {
  virtual_text = false, -- no show diagnostics in virtual line
  signs = false, -- no show diagnostics in sign column
}

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

local make_config = function()
  return {
    -- Detail of the below capabilities: https://github.com/hrsh7th/cmp-nvim-lsp/blob/main/lua/cmp_nvim_lsp/init.lua#L37
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
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
      require("plugin.lspconfig.keymap").setup()
      require('nvim-navic').attach(client, bufnr)  -- Winbar for context. Better than lspsaga.

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
