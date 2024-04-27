return {
  "stevearc/conform.nvim",
  keys = {
    { "<F12>", "<leader>cf", desc = "Format", remap = true },
  },
  opts = {
    -- https://github.com/stevearc/conform.nvim#formatters
    formatters_by_ft = {
      rust = { "rustfmt" },
      toml = { "taplo" },
      -- Remove typoes and codespell as they always makes miscorrection.
      ["*"] = { "trim_whitespace" },
    },
  },
}
