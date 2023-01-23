return {
  -- Lsp actions indicator
  "kosayoda/nvim-lightbulb",
  dependencies = {
    "antoinemadec/FixCursorHold.nvim",
  },
  event = "BufReadPost",
  opts = {
    sign = {
      enabled = false,
    },
    float = {
      enabled = false,
    },
    virtual_text = {
      enabled = true,
    },
    autocmd = {
      enabled = true,
    },
  },
}
