return {
  -- Swap and move text
  "mizlan/iswap.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>ee",
      mode = { "n", "x" },
      "<cmd>ISwapWith<CR>",
      desc = "swap current with ...",
    },
    {
      "<leader>eE",
      mode = { "n", "x" },
      "<cmd>ISwap<CR>",
      desc = "swap any two",
    },
    {
      "<leader>em",
      mode = { "n", "x" },
      "<cmd>IMoveWith<CR>",
      desc = "move current node to ...",
    },
    {
      "<leader>eM",
      mode = { "n" },
      "<cmd>IMove<CR>",
      desc = "move any to ...",
    },
  },
  init = function() require("which-key").register({ ["<leader>e"] = { name = "+swap" } }) end,
  opts = {
    move_cursor = true,
    hl_snipe = "ErrorMsg",
  },
}
