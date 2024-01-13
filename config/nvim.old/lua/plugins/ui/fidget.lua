return {
  -- Lsp progress indicator
  "j-hui/fidget.nvim",
  event = "BufReadPost",
  opts = {
    notification = {
      window = {
        winblend = 0, -- Background color opacity in the notification window
      },
    },
  },
}
