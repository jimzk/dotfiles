local M = {
  -- increment and decrement value
  "monaqa/dial.nvim",
}

M.keys = function()
  local manipulate = function(direction, mode, group_name, count)
    return function()
      require("dial.map").manipulate(direction, mode, group_name, count)
    end
  end
  local inc_key = "<C-a>"
  local dec_key = "<C-x>"
  return {
    { mode = "n", inc_key, manipulate("increment", "normal"), desc = "Increment Number/Date..." },
    { mode = "x", inc_key, manipulate("increment", "visual"), desc = "Increment Number/Date..." },
    { mode = "n", dec_key, manipulate("decrement", "normal"), desc = "Decrement Number/Date..." },
    { mode = "x", dec_key, manipulate("decrement", "visual"), desc = "Decrement Number/Date..." },
    -- Select below lines and press t and gt to see differences
    -- 1.
    -- 1.
    -- 1.
    { mode = "n", "g" .. inc_key, manipulate("increment", "gnormal"), desc = "Increment Number/Date... with Offset" },
    { mode = "x", "g" .. inc_key, manipulate("increment", "gvisual"), desc = "Increment Number/Date... with Offset" },
    { mode = "n", "g" .. dec_key, manipulate("decrement", "gnormal"), desc = "Decrement Number/Date... with Offset" },
    { mode = "x", "g" .. dec_key, manipulate("decrement", "gvisual"), desc = "Decrement Number/Date... with Offset" },
  }
end

M.opts = function()
  local augend = require("dial.augend")
  return {
    default = {
      -- augend.integer.alias.decimal, -- 0, 1, 2, ...
      augend.integer.alias.decimal_int, -- ... -1, 0 1, 2, ...
      augend.integer.alias.hex, -- 0x12, 0x13 ...
      augend.integer.alias.binary,
      augend.date.alias["%Y/%m/%d"], -- 2021/01/23, ...
      augend.date.alias["%Y-%m-%d"], -- 2021-01-04, ...
      augend.date.alias["%m/%d"], -- 01/04, 02/28, 12/25, ...
      augend.date.alias["%H:%M"], -- 14:30, ...
      -- augend.constant.alias.ja_weekday_full, -- 月曜日, 火曜日, ..., 日曜日
      -- ts-node-action provides boolean switcher
      augend.constant.alias.bool, -- bool, false
      augend.constant.alias.alpha,
      augend.constant.alias.Alpha,
      augend.semver.alias.semver, -- 0.3.0 -> 0.3.1 ..
      augend.hexcolor.new({ -- #000000, #ffffff ...
        case = "lower",
      }),
    },
  }
end

M.config = function(_, opts)
  require("dial.config").augends:register_group(opts)
end

return M
