local M = {
  -- Easily jump to any location and enhanced f/t motions for Leap
  "ggandor/leap.nvim",
  event = "VeryLazy",
}

M.keys = {
  -- {
  --   ";",
  --   function()
  --     local focusable_windows_on_tabpage = vim.tbl_filter(
  --       function(win) return vim.api.nvim_win_get_config(win).focusable end,
  --       vim.api.nvim_tabpage_list_wins(0)
  --     )
  --     require("leap").leap { target_windows = focusable_windows_on_tabpage }
  --   end,
  --   mode = { "n" },
  --   desc = "leap cross window by two keys"
  -- },
  -- {
  --   ";",
  --   function()
  --     local current_window = vim.fn.win_getid()
  --     require("leap").leap {
  --       target_windows = { current_window, },
  --       -- NOTE: forward excludes the match but backward won't for operation
  --       inclusive_op = false,
  --     }
  --   end,
  --   mode = { "x", "o" },
  --   desc = "leap current window by two keys"
  -- },

  -- { "s", "<Plug>(leap-forward-to)", mode = { "n", "x" } },
  -- { "S", "<Plug>(leap-backward-to)", mode = { "n", "x" } },
  -- { "s", "<Plug>(leap-forward-till)", mode = { "o" } },
  -- { "S", "<Plug>(leap-backward-till)", mode = { "o" } },
  -- { "g\\", "<Plug>(leap-cross-window)", mode = { "n" }, desc = "leap cross window" },
}

M.opts = {
  -- :h leap.opts.special_keys
  special_keys = {
    repeat_search = "<enter>", -- useful!
    -- NOTE: these 3 keys only work in Plug (e.g. <Plug><leap-forward-to)), but not in call of for require("leap").leap (what I configured)
    next_phase_one_target = "<enter>",
    next_target = { "n" },
    prev_target = { "N" },
    next_group = "<space>",
    prev_group = "<bs>",
    multi_accept = "<enter>",
    multi_revert = "<backspace>",
  },
  -- When the number of matches if less than number of safe_labels,
  -- 1) All matches will be labeled by safe_labels.
  -- 1) It will automatically jump to the first match.
  -- 2) After automatic jump, the leap mode won't dismiss and you can still type label to jump other match.
  -- NOTE: the above only works in Plug, but not in call of require("leap").leap
  safe_labels = {
    "f", "p", "o", "u", "b", "g", "m",
    "F", "P", "O", "U", "B", "G", "M",
    "H", "J", "K", "L"
  },
  labels = {
    "f", "j", "d", "k", "l", "h", "w", "e", "m", "b",
    "u", "y", "v", "r", "g", "t", "c", "p", "i", "n",
    "x", "z", "o", -- "a", "s", "q",
    "F", "J", "D", "K", "L", "H", "W", "E", "M", "B",
    "U", "Y", "V", "R", "G", "T", "C", "P", "I", "N",
  }
}

M.config = function(_, opts)
  local leap = require("leap")
  leap.setup(opts)
  -- Greying out the search area
  vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
  -- align with highlights of flash.nvim
  vim.cmd [[hi! link LeapMatch Substitute]]
  vim.cmd [[hi! link LeapLabelPrimary Substitute]]
  vim.cmd [[hi LeapLabelSecondary guifg=#99d1db guibg=#51576d]]
end

return M
