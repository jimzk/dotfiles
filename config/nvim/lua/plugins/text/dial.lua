return {
  -- increment and decrement value
  "monaqa/dial.nvim",
  keys = {
    { "<C-a>", "<Plug>(dial-increment)", mode = { "n", "x" }, desc = "increment number/date..." },
    { "<C-x>", "<Plug>(dial-decrement)", mode = { "n", "x" }, desc = "decrement number/date..." },
    --
    -- Set g<C-a> and g<C-x> will lose visual focus. Dont know why.
    -- { "g<C-a>", mode = { "v" }, desc = "increment number/date... with offset" },
    -- { "g<C-x>", mode = { "v" }, desc = "decrement number/date... with offset" },
  },
  init = function()
    vim.cmd([[vmap g<C-a> g<Plug>(dial-increment)]])
    vim.cmd([[vmap g<C-x> g<Plug>(dial-decrement)]])
    map("x", "g<C-a>", nil, "increment number/date ... by line index")
    map("x", "g<C-x>", nil, "decrement number/date ... by line index")
  end,
  opts = function()
    local augend = require("dial.augend")
    return {
      default = {
        augend.integer.alias.decimal, -- 0, 1, 2...
        augend.integer.alias.hex, -- 0x12, 0x13 ...
        augend.date.alias["%Y/%m/%d"], -- 2021/01/23, 2021/01/24 ...
        -- ts-node-action provides boolean switcher
        -- augend.constant.alias.bool, -- bool, false
        augend.semver.alias.semver, -- 0.3.0 -> 0.3.1 ..
        augend.hexcolor.new { -- #000000, #ffffff ...
          case = "lower",
        },
      },
    }
  end,
  config = function(_, opts)
    require("dial.config").augends:register_group(opts)
  end,
}
