return {
  "wintermute-cell/gitignore.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>gi", '<cmd>lua require("gitignore").generate()<cr>', desc = "create .gitignore" },
  },
}
