return {
  -- Make debug print smooth
  "andrewferrier/debugprint.nvim",
  keys = { "g?" },
  init = function()
    map({ "n" }, "g?p", nil, "insert debug print below line")
    map({ "n" }, "g?P", nil, "insert debug print above line")
    map({ "n", "v" }, "g?v", nil, "insert variable debug print below line")
    map({ "n", "v" }, "g?V", nil, "insert variable debug print above line")
    map({ "n" }, "g?o", nil, "debug print operation")
    map({ "n" }, "g?O", nil, "debug print operation (above line)")
    map({ "n" }, "g?<BS>", "<cmd>DeleteDebugPrints<cr>", "delete all debug prints")
  end,
  config = function(_, opts)
    require("debugprint").setup(opts)
  end,
}
