-- stylua: ignore
return {
  -- Print for debugging smoothly
  "andrewferrier/debugprint.nvim",
  keys = {
    {
      "<leader>cdp",
      function() return require("debugprint").debugprint() end,
      desc = "Print Line below",
      expr = true
    },
    {
      "<leader>cdP",
      function() return require("debugprint").debugprint({ above = true }) end,
      desc = "Print Line above",
      expr = true
    },
    {
      "<leader>cdl",
      mode = { "n", "x" },
      function() return require("debugprint").debugprint({ variable = true }) end,
      desc = "Print Variable below",
      expr = true
    },
    {
      "<leader>cdL",
      mode = { "n", "x" },
      function() return require("debugprint").debugprint({ variable = true, above = true }) end,
      desc = "Print Variable above",
      expr = true
    },
    {
      "<leader>cd<BS>",
      "<cmd>DeleteDebugPrints<cr>",
      desc = "Delete All Debug Prints",
    },
  },
  init = function()
    require("which-key").register({
      ["<leader>cd"] = { name = "+debugprint", }
    })
  end,
  opts = {
    create_keymaps = false,
    move_to_debugline = false,
    display_counter = false,
    print_tag = "DEBUG",
  },
}
