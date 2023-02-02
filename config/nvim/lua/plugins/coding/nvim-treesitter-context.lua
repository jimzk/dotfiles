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
  config = function(_, opts)
    require("treesitter-context").setup(opts)
    -- set TreesitterContext to Normal's guibg
    vim.cmd [[hi! TreesitterContext guibg=none gui=bold]]
    vim.cmd [[hi! link TreesitterContextLineNumber Normal]]
  end
}
