return {
  -- operator for duplicate
  "smjonas/duplicate.nvim",
  event = "VeryLazy",
  opts = {
    operator = {
      normal_mode = "s",
      visual_mode = "s",
      line = "ss",
    },
  }
}
