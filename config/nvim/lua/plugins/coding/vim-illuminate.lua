-- references
return {
  "RRethy/vim-illuminate",
  event = "BufReadPost",
  keys = {
    { "]v", function() require("illuminate").goto_next_reference(true) end, desc = "next variable usage", },
    { "[v", function() require("illuminate").goto_prev_reference(true) end, desc = "prev variable usage" },
    { "<C-]>", function() require("illuminate").goto_next_reference(true) end, desc = "next variable usage", },
    { "<C-[>", function() require("illuminate").goto_prev_reference(true) end, desc = "prev variable usage" },
  },
  opts = {
    -- modes_allowlist = { "n" },
    min_count_to_highlight = 1,
    filetypes_denylist = Util.unlisted_filetypes,
  },
  config = function(_, opts)
    require("illuminate").configure(opts)
    vim.cmd [[hi! IlluminatedWordText gui=underline]]
    vim.cmd [[hi! IlluminatedWordRead gui=underline]]
    vim.cmd [[hi! IlluminatedWordWrite gui=underline]]
  end,
}
