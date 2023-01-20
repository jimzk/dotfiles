return {
  -- Lsp progress indicator
  "j-hui/fidget.nvim",
  event = "BufReadPost",
  opts = {
    window = {
      blend = 100,
    },
  },
}
