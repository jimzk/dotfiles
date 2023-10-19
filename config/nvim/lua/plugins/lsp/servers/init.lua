-- Lsp list
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local servers = {
  "lua_ls",        -- Lua
  "rust_analyzer", -- Rust
  "bashls",        -- Bash
  "taplo",         -- TOML
  "jsonls",        -- JSON
  "tsserver",      -- JavaScript, TypeScript
  "pyright",       -- Python
}

local servers_opts = {}
for _, server in ipairs(servers) do
  local ok, opts = pcall(require, "plugins.lsp.servers." .. server)
  if not ok then opts = {} end
  local default_opts = require("plugins.lsp.servers.default_opts")()
  opts = vim.tbl_extend("force", default_opts, opts)
  servers_opts[server] = opts
end

return servers_opts
