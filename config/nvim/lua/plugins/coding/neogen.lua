return {
  -- Generate class/function comment
  "danymat/neogen",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  cmd = { "Neogen" },
  keys = {
    {
      "<leader>cn",
      "<cmd>Neogen<cr>",
      desc = "generate class/function comment (neogen)",
    },
  },
  opts = {}
}
