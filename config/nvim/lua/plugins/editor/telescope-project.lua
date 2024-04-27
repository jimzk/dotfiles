return {
  "nvim-telescope/telescope-project.nvim",
  enabled = true,
  keys = {
    {
      "<leader>pp",
      function()
        -- https://github.com/nvim-telescope/telescope-project.nvim
        require("telescope").extensions.project.project({
          prompt_title = "Find Git Projects",
          display_type = "minimal", -- or full
        })
      end,
      desc = "List Git Project in Workspace",
    },
  },
  config = function()
    require("telescope").setup({
      extensions = {
        project = {
          base_dirs = {
            { "~/workspace", max_depth = 5 },
            -- { "~/.local/share/nvim/lazy", max_depth = 2 },
          },
          hidden_files = true,
          display_type = "full",
          order_by = "recent",
          sync_with_nvim_tree = true,
        },
      },
    })
  end,
}
