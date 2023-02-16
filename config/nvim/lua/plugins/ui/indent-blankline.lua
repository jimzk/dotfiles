-- indent guides for Neovim
return {
  "lukas-reineke/indent-blankline.nvim",
  event = "VeryLazy",
  opts = {
    char = "│",
    filetype_exclude = Util.unlisted_filetypes,
    show_trailing_blankline_indent = false,
    show_current_context = false,
    -- use_treesitter = true,
    -- use_treesitter_scope = true,
  },
}
