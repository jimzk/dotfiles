return {
  "hiphish/rainbow-delimiters.nvim",
  event = "VeryLazy",
  enabled = true,
  opts = {},
  config = function(_, opts)
    require("rainbow-delimiters.setup").setup(opts)
  end,
}
