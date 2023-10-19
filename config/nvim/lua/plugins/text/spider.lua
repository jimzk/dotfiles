return {
  -- fine-grained word movement
  -- https://www.reddit.com/r/neovim/comments/181bsu8/my_take_on_a_word_movement/
  "chrisgrieser/nvim-spider",
  keys = {
    { "w", "<cmd>lua require('spider').motion('w')<CR>", mode = { "n", "o", "x" } },
    { "e", "<cmd>lua require('spider').motion('e')<CR>", mode = { "n", "o", "x" } },
    { "b", "<cmd>lua require('spider').motion('b')<CR>", mode = { "n", "o", "x" } },
    { "g", "<cmd>lua require('spider').motion('ge')<CR>", mode = { "n", "o", "x" } },
    { "W", "w", mode = { "n", "o", "x" } },
    { "E", "e", mode = { "n", "o", "x" } },
    { "B", "b", mode = { "n", "o", "x" } },
    { "gE", "ge", mode = { "n", "o", "x" } },
    { "<M-w>", "W", mode = { "n", "o", "x" } },
    { "<M-b>", "B", mode = { "n", "o", "x" } },
    { "<M-e>", "E", mode = { "n", "o", "x" } },
    { "g<M-e>", "gE", mode = { "n", "o", "x" } },
  },
  event = "VeryLazy",
}
