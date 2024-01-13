local M = {
  "neovim/nvim-lspconfig",
}

M.opts = {
  servers = {
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#solang
    -- solang = {},
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#solc
    solc = {},
  },
}

return M
