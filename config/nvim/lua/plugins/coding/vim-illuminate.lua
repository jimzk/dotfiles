-- references
return {
  "RRethy/vim-illuminate",
  event = "BufReadPost",
  opts = {
    -- modes_allowlist = { "n" },
    min_count_to_highlight = 1,
    filetypes_denylist = Util.unlisted_filetypes,
  },
  config = function(_, opts)
    require("illuminate").configure(opts)

    local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
    local next_ref_repeat, prev_ref_repeat = ts_repeat_move.make_repeatable_move_pair(
      function() require("illuminate").goto_next_reference(true) end,
      function() require("illuminate").goto_prev_reference(true) end)
    map("n", "]v", next_ref_repeat, "[C] next reference")
    map("n", "[v", prev_ref_repeat, "[C] prev reference")
    map("n", "<C-]>", next_ref_repeat, "[C] next reference")
    map("n", "<C-[>", prev_ref_repeat, "[C] prev reference")

    vim.cmd [[hi! IlluminatedWordText gui=underline]]
    vim.cmd [[hi! IlluminatedWordRead gui=underline]]
    vim.cmd [[hi! IlluminatedWordWrite gui=underline]]
  end,
}
