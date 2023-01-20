-- Doing: try the all files switchers and choose the best one
-- https://www.reddit.com/r/neovim/comments/10fr6gh/how_do_you_navigate_between_buffers
-- https://github.com/Yggdroot/LeaderF

return {
  "danielfalk/smart-open.nvim",
  dependencies = {
    "kkharji/sqlite.lua",
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    {
      "<leader>k",
      function()
        require("telescope").extensions.smart_open.smart_open({
          prompt_title = "Smart Open Files (cwd)",
          cwd_only = true,
        })
      end,
      desc = "open any files (smart open",
    },
    {
      "<leader>K",
      function()
        require("telescope").extensions.smart_open.smart_open({
          prompt_title = "Smart Open Files (global)",
          cwd_only = true,
        })
      end,
      desc = "open any files globally (smart open",
    },
  },
  config = function(_, opts)
    require("telescope").load_extension("smart_open")
  end,
}
