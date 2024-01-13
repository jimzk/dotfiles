return {
  "axieax/urlview.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>nu", "<CMD>UrlView lazy<CR>", desc = "Open Lazy Plugins URL" },
    { "stevearc/dressing.nvim", enabled = false },
  },
  -- https://github.com/axieax/urlview.nvim/blob/main/lua/urlview/config/default.lua
  opts = {
    default_picker = "native",
    jump = {
      prev = "",
      next = "",
    },
  },
}
