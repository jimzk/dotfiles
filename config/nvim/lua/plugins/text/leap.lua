local M = {
  -- Easily jump to any location and enhanced f/t motions for Leap
  "ggandor/leap.nvim",
  event = "VeryLazy",
}

M.keys = {
  { "\\", function()
    local focusable_windows_on_tabpage = vim.tbl_filter(
      function(win) return vim.api.nvim_win_get_config(win).focusable end,
      vim.api.nvim_tabpage_list_wins(0)
    )
    require("leap").leap { target_windows = focusable_windows_on_tabpage }
  end, mode = { "n" }, desc = "leap cross window" },
  { "\\", function()
    local current_window = vim.fn.win_getid()
    require("leap").leap {
      target_windows = { current_window, },
      -- NOTE: forward excludes the match but backward won't for operation
      inclusive_op = false,
    }
  end, mode = { "x", "o" }, desc = "leap current window" },
  -- { "s", "<Plug>(leap-forward-to)", mode = { "n", "x" } },
  -- { "S", "<Plug>(leap-backward-to)", mode = { "n", "x" } },
  -- { "s", "<Plug>(leap-forward-till)", mode = { "o" } },
  -- { "S", "<Plug>(leap-backward-till)", mode = { "o" } },
  -- { "g\\", "<Plug>(leap-cross-window)", mode = { "n" }, desc = "leap cross window" },
}

M.opts = {
  -- :h leap.opts.special_keys
  special_keys = {
    repeat_search = "<enter>",
    -- NOTE: these 3 keys do not work for customized leap.leap
    next_phase_one_target = "<enter>",
    next_target = { "n" },
    prev_target = { "N" },
    next_group = "<space>",
    prev_group = "<bs>",
    multi_accept = "<enter>",
    multi_revert = "<backspace>",
  },
  -- Typing these keys won't exit leap mode
  safe_labels = {
    "f", "i", "o", "u", "b", "g", "m",
    "F", "I", "O", "U", "B", "G", "M",
    "J", "K",
  },
  labels = {
    "f", "j", "k", "l", "h", "o", "d", "w", "e", "m", "b",
    "F", "J", "K", "L", "H", "O", "D", "W", "E", "M", "B",
    "u", "y", "v", "r", "g", "t", "c",
    "U", "Y", "V", "R", "G", "T", "C",
    "x", "z",
  }
}

M.config = function(_, opts)
  local leap = require("leap")
  leap.setup(opts)
  -- Greying out the search area
  vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
end

return M
