-- https://github.com/nvim-telescope/telescope-project
-- Need to delete ~/.local/share/nvim/telescope-projects.txt by manual if finding extract items
local telescope = require("telescope")
telescope.setup {
  extensions = {
    project = {
      base_dirs = {
        { '~/workspace', max_depth = 4 },
        { '~', max_depth = 2 },
      },
      hidden_files = true,
      -- theme = "dropdown",
      display_type = 'full',
      order_by = "recent",
      sync_with_nvim_tree = true,
    }
  }
}
telescope.load_extension('project')
