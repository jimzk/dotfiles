return {
  -- operator for duplicate
  "smjonas/duplicate.nvim",
  event = "VeryLazy",
  opts = {
    operator = {
      normal_mode = "<M-d>",
      visual_mode = "<M-d>",
      line = "<M-d><M-d>",
    },
  }
}
