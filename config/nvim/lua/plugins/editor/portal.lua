return {
  -- Navigate by popup windows for changelist, quifkfix, grapple, harpoon
  "cbochs/portal.nvim",
  dependencies = {
    "cbochs/grapple.nvim",
    -- "ThePrimeagen/harpoon"
  },
  event = "VeryLazy",
  enabled = false,
  keys = {
    {
      "<C-c>",
      function()
        require("portal.builtin").grapple.tunnel()
      end,
      desc = "Select File (Grapple)",
    },
  },
  opts = {
    labels = { "j", "k", "h", "l", "y", "u", "i", "o" },
    select_first = true,
  },
}
