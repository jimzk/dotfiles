return {
  "stevearc/conform.nvim",
  keys = {
    { "<F12>", "<leader>cf", desc = "Format", remap = true },
  },
  opts = {
    -- https://github.com/stevearc/conform.nvim#formatters
    formatters_by_ft = {
      -- Conform will run multiple formatters sequentially
      python = { "black", "isort" },
      rust = { "rustfmt" },
      -- Use a sub-list to run only the first available formatter
      javascript = { { "biome", "prettierd", "prettier" } },
      json = { { "prettierd", "prettier" } },
      toml = { "taplo" },
      yaml = { "yamlfix" },
      markdown = { "injected" },
      -- Remove typoes and codespell as they always makes miscorrection.
      ["*"] = { "trim_whitespace" },
    },
  },
}
