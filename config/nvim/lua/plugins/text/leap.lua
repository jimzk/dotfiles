return {
  -- easily jump to any location and enhanced f/t motions for Leap
  "ggandor/leap.nvim",
  keys = {
    { "f", "<Plug>(leap-forward-to)", mode = { "n", "x" } },
    { "F", "<Plug>(leap-backward-to)", mode = { "n", "x" } },
    { "f", "<Plug>(leap-forward-till)", mode = { "o" } },
    { "F", "<Plug>(leap-backward-till)", mode = { "o" } },
    { "gf", "<Plug>(leap-cross-window)", mode = { "n" }, desc = "leap cross window" },
  },
  -- stylua: ignore
  opts = {
    -- :h leap.opts.special_keys
    special_keys = {
      -- f<cr> to repeat search
      repeat_search = "<cr>",
      next_phase_one_target = "<cr>",
      next_target = { "n" },
      prev_target = { "N" },
      next_group = "<tab>",
      prev_group = "<s-tab>",
      multi_accept = "<enter>",
      multi_revert = "<backspace>",
    },
    -- remove n and N
    safe_labels =
    { "s", "f", "i", "o", "u", "t", "b", "g",
      "S", "F", "I", "O", "U", "L", "H", "M", "J", "K", "G" },
    labels = { "s", "f",
      "j", "k", "l", "h", "o", "d", "w", "e", "m", "b",
      "u", "y", "v", "r", "g", "t", "c", "x", "z",
      "S", "F",
      "J", "K", "L", "H", "O", "D", "W", "E", "M", "B",
      "U", "Y", "V", "R", "G", "T", "C" }
  },
  config = function(_, opts)
    local leap = require("leap")
    leap.setup(opts)
    -- Greying out the search area
    vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
  end,
}
