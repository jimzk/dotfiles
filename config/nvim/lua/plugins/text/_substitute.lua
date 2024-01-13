return {
  -- Exchange text
  -- Replaced by mini.operator
  "gbprod/substitute.nvim",
  event = "BufReadPost",
  enabled = false,
  keys = function()
    local substitute = require("substitute")
    local exchange = require("substitute.exchange")
    return {
      { "sb", exchange.operator, desc = "Exchange Operator" },
      { "sbb", exchange.line, desc = "Exchange Line" },
      -- ISSUE: in visual ss will jump to another buffer
      { "sb", mode = "x", exchange.visual, desc = "Exchange Visual" },
      -- { "sv", substitute.operator, desc = "Replacement" },
      -- { "svv", substitute.line, desc = "Replacement Line" },
    }
  end,
  opts = {},
  config = function(_, opts)
    opts.on_substitute = require("yanky.integration").substitute()
    require("substitute").setup(opts)
  end,
}
