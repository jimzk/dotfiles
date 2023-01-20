-- indent guides for Neovim
return {
  "lukas-reineke/indent-blankline.nvim",
  event = "VeryLazy",
  opts = {
    -- char = "▏",
    char = "│",
    filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
    show_trailing_blankline_indent = false,
    show_current_context = false,
    -- use_treesitter = true,
    -- use_treesitter_scope = true,
  },
}
