return {
  -- Highlight text
  "Pocco81/high-str.nvim",
  enabled = false,
  cmd = {
    "HSExport",
    "HSImport",
  },
  keys = {
    { "sh", ":<C-u>HSHighlight 1<cr>", mode = "v", desc = "Highlight Visual", silent = true },
    { "sh", "viw:<C-u>HSHighlight 1<cr>", mode = "n", desc = "Highlight Text", silent = true },
    { "sH", "<cmd>HSRmHighlight rm_all<cr>", mode = "n", desc = "Highlight Text Remove", silent = true },
  },
  opts = {
    saving_path = vim.fn.getenv("HOME") .. "/.cache/nvim/high-str/",
  },
}
