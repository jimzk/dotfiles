return {
  "nvim-telescope/telescope-project.nvim",
  event = "VeryLazy",
  enabled = true,
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
