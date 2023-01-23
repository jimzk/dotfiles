return {
  -- Show function context in first line
  "nvim-treesitter/nvim-treesitter-context",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = "VeryLazy",
  opts = {
    patterns = {
      default = {
        "class",
        "function",
        "method",
        "interface",
        "struct",
        "enum",
      },
    },
  },
}
