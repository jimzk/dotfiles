return {
  "kylechui/nvim-surround",
  event = "VeryLazy",
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
      normal = "ys",
      normal_cur = "yss",
      normal_line = "yS",
      normal_cur_line = "ySS",
      visual = "s",
      visual_line = "gs",
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
