return {
  -- Automatically close unmodified buffers if numbers of buffers exceed the threshold
  "axkirillov/hbac.nvim",
  event = "BufRead",
  opts = {
    threshold = 10
  }
}
