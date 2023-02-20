return {
  -- Make debug print smooth
  "andrewferrier/debugprint.nvim",
  keys = { "g?" },
  init = function()
    map({ "n" }, "<leader>cdp", nil, "insert debug print below line")
    map({ "n" }, "<leader>cdP", nil, "insert debug print above line")
    map({ "n", "v" }, "<leader>cdv", nil, "insert variable debug print below line")
    map({ "n", "v" }, "<leader>cdV", nil, "insert variable debug print above line")
    map({ "n" }, "<leader>cdo", nil, "debug print operation")
    map({ "n" }, "<leader>cdO", nil, "debug print operation (above line)")
    map({ "n" }, "<leader>cd<BS>", "<cmd>DeleteDebugPrints<cr>", "delete all debug prints")
  end,
  config = function(_, opts)
    require("debugprint").setup(opts)
  end,
}
