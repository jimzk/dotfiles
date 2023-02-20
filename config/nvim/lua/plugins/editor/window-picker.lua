return {
  "s1n7ax/nvim-window-picker",
  event = "VeryLazy",
  keys = {
    { "<tab>", Util.focus_win, desc = "pick a window", mode = { "n", "x", } }
  },
  opts = {
    -- include_current_win = true,
    -- selection_chars = " FJDKSLA;CMRUEIWOQP",
    filter_rules = {
      bo = {
        filetype = { "NvimTree", "neo-tree", "notify", "aerial" },
        -- buftype = { "terminal" },
        buftype = { "terminal" },
      },
    },
    other_win_hl_color = "#e35e4f",
    current_win_hl_color = "#44cc41",
  },
}
