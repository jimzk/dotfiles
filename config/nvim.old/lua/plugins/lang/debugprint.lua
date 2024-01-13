return {
  -- Print for debugging smoothly
  "andrewferrier/debugprint.nvim",
  keys = {
    {
      "<leader>dp",
      function() return require("debugprint").debugprint() end,
      desc = "print current line below for debugging",
      expr = true
    },
    {
      "<leader>dP",
      function() return require("debugprint").debugprint({ above = true }) end,
      desc = "print current line above for debugging",
      expr = true
    },
    {
      "<leader>dv",
      mode = { "n", "x" },
      function() return require("debugprint").debugprint({ variable = true }) end,
      desc = "print variable below for debugging",
      expr = true
    },
    {
      "<leader>dV",
      mode = { "n", "x" },
      function() return require("debugprint").debugprint({ variable = true, above = true }) end,
      desc = "print variable above for debugging",
      expr = true
    },
    {
      "<leader>d<BS>",
      "<cmd>DeleteDebugPrints<cr>",
      desc = "delete all debug prints",
    },
  },
  init = function()
    require("which-key").register({
      ["<leader>d"] = { name = "+debugprint", }
    })
  end,
  opts = {
    create_keymaps = false,
    move_to_debugline = false,
  },
}
