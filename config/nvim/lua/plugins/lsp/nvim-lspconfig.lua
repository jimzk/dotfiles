-- lspconfig
local M = {
  "neovim/nvim-lspconfig",
  event = "BufReadPost",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "williamboman/mason.nvim",
    "hrsh7th/cmp-nvim-lsp",
    -- Signature help for neovim method
    { "folke/neodev.nvim", config = true },
  },
}

local config_diagnostic = function()
  local diagnostics = {
    underline = true,
    update_in_insert = false,
    virtual_text = { spacing = 4, prefix = "●" },
    severity_sort = true,
    float = {
      show_header = true,
      -- source = "if_many",
      border = "single",
      focusable = false,
    },
  }
  for name, _ in pairs(require("config").icons.diagnostics) do
    name = "DiagnosticSign" .. name
    -- vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
    vim.fn.sign_define(name, { numhl = name })
  end
  vim.diagnostic.config(diagnostics)
end

M.config = function()
  -- setup formatting and keymaps
  Util.on_attach(function(client, buffer)
    require("plugins.lsp.format").on_attach(client, buffer)
    require("plugins.lsp.keymaps").on_attach(buffer)
  end)

  config_diagnostic()

  local servers = require("plugins.lsp.servers")
  require("mason").setup()
  require("mason-lspconfig").setup({ ensure_installed = vim.tbl_keys(servers) })
  for server, opts in pairs(servers) do
    require("lspconfig")[server].setup(opts)
  end
end

return M
