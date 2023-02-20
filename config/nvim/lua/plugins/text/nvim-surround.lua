return {
  "kylechui/nvim-surround",
  event = "BufReadPost",
  -- keys = { "cs", "ds", "ys", { "Y", mode = { "x" } } },
  --
  -- :h nvim-surround.config.keymaps
  -- Tip:
  --  ysiwf: surrounded by function
  --  ysiwi{char1}{char2}: input left and right surrounds
  opts = {
    keymaps = {
      insert = false,
      insert_line = false,
      -- add surrounds by s
      normal = "s",
      normal_cur = "ss",
      normal_line = "S",
      normal_cur_line = "SS",
      visual = "s",
      visual_line = "S",
    },
    surrounds = {
      o = {
        add = { "<", ">" },
      },
      O = {
        add = { "[", "]" },
      },
      q = {
        add = { '"', '"' },
      },
    },
    aliases = {
      o = { ">" },
      O = { "]" },
    },
    move_cursor = false,
  },
}
