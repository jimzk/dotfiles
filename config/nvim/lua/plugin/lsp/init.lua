require("mason").setup()
require("mason-lspconfig").setup()

local servers = require("plugin.lsp.servers")
local servers_list = servers.get_list()
require("mason-lspconfig").setup({
  ensure_installed = servers_list,
})

servers.setup()
for _, server in pairs(servers_list) do
  local config = servers.get_config(server)
  require('lspconfig')[server].setup(config)
end
servers.post_setup()

-- https://github.com/ldelossa/litee-calltree.nvim/issues/13
require('litee.lib').setup({
  panel = {
    orientation = "right",
    panel_size  = 50,
  },
})
require('litee.calltree').setup({})

require("plugin.lsp.lspsaga")
