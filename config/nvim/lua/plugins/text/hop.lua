return {
  -- EasyMotion-like plugin. I only use it for enhanced f/t motions.
  "phaazon/hop.nvim",
  -- HopNextKey1Fix bug: https://github.com/phaazon/hop.nvim/issues/345#issuecomment-1366006446
  commit = "caaccee",
  keys = {
    {"f", mode = {"n", "x", "o"}},
    {"F", mode = {"n", "x", "o"}},
  },
  opts = {},
  config = function(_, opts)
    local hop = require("hop")
    hop.setup(opts)
    local directions = require("hop.hint").HintDirection
    map({ "n", "x" }, "f", function()
      hop.hint_char1 { direction = directions.AFTER_CURSOR, current_line_only = false }
    end)
    map({ "n", "x" }, "F", function()
      hop.hint_char1 { direction = directions.BEFORE_CURSOR, current_line_only = false }
    end)
    map("o", "f", function()
      hop.hint_char1 { direction = directions.AFTER_CURSOR, current_line_only = false, hint_offset = -1 }
    end)
    map("o", "F", function()
      hop.hint_char1 { direction = directions.BEFORE_CURSOR, current_line_only = false, hint_offset = 1 }
    end)
    vim.cmd [[hi! link HopNextkey LeapLabelPrimary]]
  end
}
