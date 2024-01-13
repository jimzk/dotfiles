local M = {
  -- Has some bugs but much smoother than rustaceanvim
  "jimzk/rust-tools.nvim",
  ft = { "rust" },
}

M.dependencies = {
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
        rust_analyzer = function() end,
      },
    },
  },
}

M.opts = function()
  return {
    server = require("plugins.lsp.rust-tools.rust-analyzer-opts"),
  }
end

M.config = function(_, opts)
  require("rust-tools").setup(opts)
end

return M
