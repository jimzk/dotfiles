local M = {
  -- A heavily modified fork of rust-tools
  -- ISSUE: very lagging, specially for inlay hints
  "mrcjkb/rustaceanvim",
  version = "^4",
  ft = { "rust" },
}

M.dependencies = {
  -- TODO: fix dap
  -- "mfussenegger/nvim-dap",
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        taplo = {
          keys = {
            {
              "K",
              function()
                if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                  require("crates").show_popup()
                else
                  vim.lsp.buf.hover()
                end
              end,
              desc = "Show Crate Documentation",
            },
          },
        },
      },
      setup = {
        -- Remove rust-tools setup
        -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/rust.lua#L141
        rust_analyzer = function()
          return true
        end,
      },
    },
  },
  {
    "simrat39/rust-tools.nvim",
    enabled = false,
  },
}

M.config = function()
  -- local server_opts = {}
  -- https://github.com/mrcjkb/rustaceanvim/blob/master/lua/rustaceanvim/config/internal.lua
  vim.g.rustaceanvim = {
    tools = {
      hover_actions = {
        auto_focus = false,
      },
    },
    server = require("plugins.lsp.rustaceanvim.rust-analyzer-opts"),
    -- https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/plugins/extras/lang/rust.lua#L73
    -- TODO: test performance
    -- on_initialized = function()
    --   vim.cmd([[
    --       augroup RustLSP
    --         autocmd CursorHold                      *.rs silent! lua vim.lsp.buf.document_highlight()
    --         autocmd CursorMoved,InsertEnter         *.rs silent! lua vim.lsp.buf.clear_references()
    --         autocmd BufEnter,CursorHold,InsertLeave *.rs silent! lua vim.lsp.codelens.refresh()
    --       augroup END
    --     ]])
    -- end,
  }
end

return M
