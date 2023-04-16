return {
  "Pocco81/high-str.nvim",
  keys = {
    { "<leader>jh", ":<C-u>HSHighlight 1<cr>", mode = "v", desc = "highlight visual (high-str)", silent = true },
    { "<leader>jh", "viw:<C-u>HSHighlight 1<cr>", mode = "n", desc = "highlight text (high-str)", silent = true },
    { "<leader>jH", "<cmd>HSRmHighlight rm_all<cr>", mode = "n", desc = "cancel highlight (high-str)", silent = true },
    { "<leader>j<C-h>", "<cmd>HSRmHighlight<cr>", mode = "n", desc = "cancel highlight all (high-str)", silent = true },
  },
}
