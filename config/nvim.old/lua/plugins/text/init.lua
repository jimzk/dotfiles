local M = Util.load_specs("text")

M = Util.tbl_combine(M, {
  -- makes some plugins dot-repeatable like leap
  { "tpope/vim-repeat", event = "VeryLazy" },
})

return M
