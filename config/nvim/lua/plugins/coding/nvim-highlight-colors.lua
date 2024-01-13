return {
  -- Comparation with nvim-colorizer: https://www.reddit.com/r/neovim/comments/1b5gw12/comment/kt57ft5
  "brenoprata10/nvim-highlight-colors",
  event = "VeryLazy",
  keys = {
    {
      "<leader>oH",
      function()
        require("nvim-highlight-colors").toggle()
      end,
      desc = "Toggle Color Highlight",
    },
  },
  opts = {},
}
