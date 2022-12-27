-- From: https://github.com/seblj/dotfiles/blob/master/nvim/lua/config/lspconfig/settings.lua
-- Avaliable lsp servers https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
--            Short list https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
local M = {}

local lsp_status = require("lsp-status")
M.setup = function()
  vim.diagnostic.config({
    virtual_text = { spacing = 2, prefix = '●' },
    float = { border = 'single', source = 'if_many' }, -- float window
    signs = false,
    update_in_insert = false,
  })

  lsp_status.config {
    diagnostics = false, -- No show diagnostics
  }
  lsp_status.register_progress()
end

local create_default_config = function()
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
      ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'single' }),
      ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'single' }),
    },
    on_attach = function(client, bufnr)
      -- Enable completion triggered by <c-x><c-o>
      vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
      -- Code context used by lualine. Better than lspsaga.
      require('nvim-navic').attach(client, bufnr)
      require("plugin.lsp.keymap").setup(bufnr)
    end,
  }
end

local servers_list = {
  "sumneko_lua", -- Lua
  "rust_analyzer", -- Rust
  "bashls", -- Bash
  "zk", -- Markdown
  "taplo", -- TOML
  "yamlls", -- YAML
  "jsonls", -- JSON
}

local configs = {}
for _, server in pairs(servers_list) do
  local config = create_default_config()
  local status, p = pcall(require, 'plugin.lsp.servers.' .. server)
  if status and p.create_config then
    config = p.create_config(config)
  end
  configs[server] = config
end

-- require("plugin.lsp.servers.sumneko_lua").setup(configs)

M.get_config = function(server)
  return configs[server]
end

M.get_list = function()
  return servers_list
end

M.post_setup = function()
  require("plugin.lsp.servers.rust_analyzer").post_setup(configs)
end

return M
