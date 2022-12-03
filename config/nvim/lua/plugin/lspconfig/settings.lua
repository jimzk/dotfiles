-- From: https://github.com/seblj/dotfiles/blob/master/nvim/lua/config/lspconfig/settings.lua
-- Avaliable lsp servers https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
--            Short list https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
local settings = {
  sumneko_lua = { -- Lua
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT'
        },
        diagnostics = {
          -- Get the language server to recognize the global `vim`
          globals = {'vim'}
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false
        },
        completion = {
          callSnippet = "Replace" -- Complete with arguments
        }
      }
    }
  },
  rust_analyzer = {}, -- Rust
  bashls = {}, -- Bash
  zk = {}, -- Markdown
  taplo = {}, -- TOML
  yamlls = {}, -- YAML
  jsonls = {} -- JSON
}

return settings
