return {
  -- Lsp progress indicator
  "j-hui/fidget.nvim",
  tag = "legacy",
  event = "BufReadPost",
  opts = {
    window = {
      blend = 100,
    },
  },
}
