local M = Util.load_specs("editor")

M = Util.tbl_combine(M, {
  -- Delete buffer without messing up layout
  { "moll/vim-bbye", cmd = { "Bwipeout", "Bdelete" } },
  -- Auto detect indent width
  { "tpope/vim-sleuth", lazy = false },
})
return M
