return {
  -- Generate class/function comment
  "danymat/neogen",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  cmd = { "Neogen" },
  keys = {
    {
      "<leader>cn",
      "<cmd>Neogen<cr>",
      desc = "Generate Class/Function Comment (neogen)",
    },
  },
  opts = {},
}
