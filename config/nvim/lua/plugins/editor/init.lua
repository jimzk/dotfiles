-- local M = Util.read_specs("plugins.editor", {
--   "neo-tree",
--   "nvim-spectre",
--   "telescope",
--   "telescope-frecency",
--   "telescope-project",
--   "which-key",
--   "gitsigns",
--   "mini-bufremove",
--   "trouble",
--   "todo-comments",
--   "persistence",
--   "nvim-ufo",
--   "nvim-bqf",
--   "fzf-lua",
--   "mind",
--   "toggleterm",
--   "harpoon",
--   "undotree",
--   "vim-maximizer",
-- })

-- M = Util.tbl_combine(M, {
--   -- Delete buffer without messing up layout
--   { "moll/vim-bbye", cmd = { "Bwipeout", "Bdelete" } },
--   -- Auto detect indent width
--   { "tpope/vim-sleuth", lazy = false }
-- })

-- return M

local M = Util.load_specs("editor")

M = Util.tbl_combine(M, {
  -- Delete buffer without messing up layout
  { "moll/vim-bbye", cmd = { "Bwipeout", "Bdelete" } },
  -- Auto detect indent width
  { "tpope/vim-sleuth", lazy = false }
})
return M
