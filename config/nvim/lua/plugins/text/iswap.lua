return {
  -- Swap and move text
  "mizlan/iswap.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>jK",
      mode = { "n", "x" },
      "<cmd>ISwapWith<CR>",
      desc = "swap current with ...",
    },
    {
      "<leader>j<C-k>",
      mode = { "n", "x" },
      "<cmd>ISwap<CR>",
      desc = "swap any two",
    },
    {
      "<leader>jm",
      mode = { "n" },
      "<cmd>IMoveWith<CR>",
      desc = "move current to..",
    },
    {
      "<leader>jM",
      mode = { "n" },
      "<cmd>IMove<CR>",
      desc = "move any to ..",
    },
  },
  opts = {
    move_cursor = true,
    hl_snipe = "ErrorMsg",
  }
}
