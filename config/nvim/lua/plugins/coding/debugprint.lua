-- stylua: ignore
return {
  -- Print for debugging smoothly
  "andrewferrier/debugprint.nvim",
  keys = {
    {
      "<leader>el",
      function() return require("debugprint").debugprint() end,
      desc = "Debug Print Line Below",
      expr = true
    },
    {
      "<leader>eL",
      function() return require("debugprint").debugprint({ above = true }) end,
      desc = "Debug Print Line Above",
      expr = true
    },
    {
      "<leader>ev",
      mode = { "n", "x" },
      function() return require("debugprint").debugprint({ variable = true }) end,
      desc = "Debug Print Variable Below",
      expr = true
    },
    {
      "<leader>eV",
      mode = { "n", "x" },
      function() return require("debugprint").debugprint({ variable = true, above = true }) end,
      desc = "Debug Print Variable Above",
      expr = true
    },
    {
      "<leader>ed",
      "<cmd>DeleteDebugPrints<cr>",
      desc = "Debug Print Clean",
    },
  },
  opts = {
    move_to_debugline = false,
    display_counter = false,
    print_tag = "DEBUG",
  },
}
