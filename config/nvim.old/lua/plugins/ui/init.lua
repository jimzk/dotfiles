local M = Util.load_specs("ui")

M = Util.tbl_combine(M, {
  -- icons
  "nvim-tree/nvim-web-devicons",
  -- ui components
  "MunifTanjim/nui.nvim",
})

return M
