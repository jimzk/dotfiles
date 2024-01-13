-- indent guides for Neovim
-- https://www.reddit.com/r/neovim/comments/16u5abl/indent_blankline_v3_is_released/
return {
  "lukas-reineke/indent-blankline.nvim",
  event = "VeryLazy",
  opts = {
    indent = { char = "┃" }
  },
  config = function(_, opts)
    require("ibl").setup(opts)
  end,
}
