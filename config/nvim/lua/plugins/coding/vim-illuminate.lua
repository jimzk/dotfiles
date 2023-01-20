-- references
return {
  "RRethy/vim-illuminate",
  event = "BufReadPost",
  keys = {
    { "]v", function() require("illuminate").goto_next_reference(true) end, desc = "next variable usage", },
    { "[v", function() require("illuminate").goto_prev_reference(true) end, desc = "prev variable usage" },
  },
  init = function()
    -- ignore default keymaps in which-key
    map({ "n", "o" }, "<M-i>")
    map("n", "<M-p>")
    map("n", "<M-n>")
  end,
  opts = { delay = 200 },
  config = function(_, opts)
    require("illuminate").configure(opts)
    -- vim.cmd [[hi! IlluminatedWordText gui=underline]]
    -- vim.cmd [[hi! IlluminatedWordRead gui=underline]]
    -- vim.cmd [[hi! IlluminatedWordWrite gui=underline]]
  end,
}
