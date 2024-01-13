return {
  -- Navigate by popup windows for changelist, quifkfix, grapple, harpoon
  "cbochs/portal.nvim",
  dependencies = {
    "cbochs/grapple.nvim",
    -- "ThePrimeagen/harpoon"
  },
  event = "VeryLazy",
  keys = {
    {
      "<leader>q",
      function()
        require("portal.builtin").quickfix.tunnel()
      end,
      desc = "Navigate Quickfix",
    },
  },
  opts = {},
}
