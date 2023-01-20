return {
  -- Show function context in first line
  "nvim-treesitter/nvim-treesitter-context",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = "VeryLazy",
  config = function()
    require("treesitter-context").setup {}
  end
}
