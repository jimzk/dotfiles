-- https://github.com/ahmedkhalf/project.nvim
local telescope = require('telescope')

-- FIX: https://github.com/ahmedkhalf/project.nvim/issues/103
-- require("project_nvim").setup {
--   exclude_dirs = {},
--   show_hidden = true,
--   -- silent_chdir = false,  -- show message when project.nvim changes working directory.
--   datapath = vim.fn.stdpath("data"),  -- path to store project data
-- }
telescope.load_extension('projects')
