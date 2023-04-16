return {
  -- Print for debugging smoothly
  "andrewferrier/debugprint.nvim",
  keys = {
    {
      "<leader>Dp",
      function() return require("debugprint").debugprint() end,
      desc = "print current line below for debugging",
      expr = true
    },
    {
      "<leader>DP",
      function() return require("debugprint").debugprint({ above = true }) end,
      desc = "print current line above for debugging",
      expr = true
    },
    {
      "<leader>Dv",
      mode = { "n", "x" },
      function() return require("debugprint").debugprint({ variable = true }) end,
      desc = "print variable below for debugging",
      expr = true
    },
    {
      "<leader>DV",
      mode = { "n", "x" },
      function() return require("debugprint").debugprint({ variable = true, above = true }) end,
      desc = "print variable above for debugging",
      expr = true
    },
    {
      "<leader>D<BS>",
      "<cmd>DeleteDebugPrints<cr>",
      desc = "delete all debug prints",
    },
  },
  opts = {
    create_keymaps = false,
    move_to_debugline = false,
  },
}
