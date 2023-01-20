-- :h nvim-surround.config.keymaps
-- Tip:
--  ysiwf: surrounded by function
--  ysiwi{char1}{char2}: input left and right surrounds
require("nvim-surround").setup({
  keymaps = {
    insert = false,
    insert_line = false,
    visual = "Y",
    visual_line = "gY",
  },
  surrounds = {
    r = {
      add = { "[", "]" },
    },
    k = {
      add = { "<", ">" },
    },
    q = {
      add = { '"', '"' },
    },
  },
  aliases = {
    ["k"] = { ">" },
    ["r"] = { "]" },
  },
  move_cursor = false,
})
