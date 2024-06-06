local M = {
  -- increment and decrement value
  "monaqa/dial.nvim",
}

M.opts = function(_, opts)
  local augend = require("dial.augend")
  opts.groups.default = {
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
  }

  return opts
end

return M
