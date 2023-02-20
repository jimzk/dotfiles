return {
  -- Automatically install sources in null-ls
  "jay-babu/mason-null-ls.nvim",
  event = "VeryLazy",
  dependencies = {
    "williamboman/mason.nvim",
    "jose-elias-alvarez/null-ls.nvim",
  },
  opts = {
    ensure_installed = nil,
    automatic_installation = true,
    automatic_setup = false,
  }
}
