return {
  "williamboman/mason.nvim",
  cmd = "Mason",
  opts = {
    -- https://github.com/williamboman/mason.nvim/blob/main/PACKAGES.md
    -- Should install DAP/Linter/Formatter here.
    -- LSP can will be installed by mason-lspconfig.
    ensure_installed = {
      "shfmt",
      "stylua",
    }
  },
}
