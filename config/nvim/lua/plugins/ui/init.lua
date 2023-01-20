-- local M = Util.read_specs("plugins.ui", {
--   "nvim-notify",
--   "dressing",
--   "lualine",
--   "indent-blankline",
--   "mini-indentscope",
--   "noice",
--   "alpha",
--   "nvim-navic",
--   "zen-mode",
--   "barbecue",
--   "marks",
--   "scrollbar",
-- })

-- M = Util.tbl_combine(M, {
--   -- icons
--   "nvim-tree/nvim-web-devicons",
--   -- ui components
--   "MunifTanjim/nui.nvim",
-- })

-- return M

local M = Util.load_specs("ui")

M = Util.tbl_combine(M, {
  -- icons
  "nvim-tree/nvim-web-devicons",
  -- ui components
  "MunifTanjim/nui.nvim",
})

return M
