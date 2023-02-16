-- references
return {
  "RRethy/vim-illuminate",
  event = "BufReadPost",
  keys = {
    { "]v", function() require("illuminate").goto_next_reference(true) end, desc = "next variable usage", },
    { "[v", function() require("illuminate").goto_prev_reference(true) end, desc = "prev variable usage" },
  },
  opts = {
    modes_allowlist = { "n" },
    delay = 200,
    min_count_to_highlight = 2,
    filetypes_denylist = Util.unlisted_filetypes,
  },
  config = function(_, opts)
    require("illuminate").configure(opts)
    vim.cmd [[hi! IlluminatedWordText guibg=none gui=underline]]
    vim.cmd [[hi! IlluminatedWordRead guibg=none gui=underline]]
    vim.cmd [[hi! IlluminatedWordWrite guibg=none gui=underline]]
  end,
}
