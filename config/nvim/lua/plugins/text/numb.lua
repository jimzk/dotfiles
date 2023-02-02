return {
  -- Peek line for :numb
  "nacro90/numb.nvim",
  event = "VeryLazy",
  opts = {
    -- Only pick for :22 but not for :22t.
    number_only = true,
  }
}
