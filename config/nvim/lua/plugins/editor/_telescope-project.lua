return {
  "nvim-telescope/telescope-project.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  event = "VeryLazy",
  config = function()
    local ts = require("telescope")
    ts.setup({
      extensions = {
        project = {
          base_dirs = {
            { "~/workspace", max_depth = 4 },
            { "~", max_depth = 2 },
          },
          hidden_files = true,
          -- theme = "dropdown",
          display_type = "full",
          order_by = "recent",
          sync_with_nvim_tree = true,
        },
      },
    })
    ts.load_extension("project")
  end,
}
