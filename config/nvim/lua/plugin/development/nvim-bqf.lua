require('bqf').setup {
  -- https://github.com/kevinhwang91/nvim-bqf#function-table
  func_map = {
    drop = "o", -- jump and close qf
    open = "<cr>", -- jump but not close qf
    openc = "",
    prevfile = "K",
    nextfile = "J",
    split = "s",
    vsplit = "v",
    ptogglemode = "=", -- toggle preview window size
    pscrollorig = "-", -- scroll back original position in preview window
  }
}
