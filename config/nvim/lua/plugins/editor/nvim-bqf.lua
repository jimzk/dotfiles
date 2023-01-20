return {
  -- Better quick fix
  "kevinhwang91/nvim-bqf",
  ft = "qf",
  opts = {
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
    },
  },
  config = function(_, opts)
    require("bqf").setup(opts)
    -- First line in qf is fix line. Make it highlight identical with other lines.
    -- https://github.com/neovim/neovim/issues/5722#issuecomment-648820525
    vim.cmd([[hi QuickFixLine cterm=bold ctermfg=none ctermbg=none guibg=none]])
    -- vim.cmd([[hi! link BqfPreviewCursor BqfPreviewRange]])
  end,
}
