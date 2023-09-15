-- which-key
return {
  "folke/which-key.nvim",
  event = "BufReadPre",
  priority = 10,
  opts = {
    plugins = {
      marks = false,      -- shows a list of your marks on ' and `
      registers = true,   -- shows your registers on " in NORMAL or <C-r> in INSERT mode
      spelling = {
        enabled = true,   -- enabling this will show WhichKey when pressing z= to select spelling suggestions
        suggestions = 20, -- how many suggestions should be shown in the list?
      },
      -- disable most presets and set my customized keymap
      -- https://github.com/folke/which-key.nvim/blob/main/lua/which-key/plugins/presets/init.lua
      presets = {
        operators = false,
        motions = false,
        text_objects = false,
        windows = false,
        nav = false,
        z = false,
        g = false,
      },
    },
    -- add operators that will trigger motion and text object completion
    operators = {
      gc = "comment", -- vim-commentary
      c = "change",   -- compatible with keymap register of multi-select
      d = "delete",
      v = "visual",
      y = "yank",
    },
    window = {
      border = "single", -- none, single, double, shadow
    },
    layout = {
      height = { min = 5, max = 80 }, -- min and max height of the columns
    },
    show_help = true,                 -- whethre show help message on the command line when the popup is visible
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.register({
      ["<leader>"] = {
        name = "+leader",
        c = {
          name = "+code",
          mode = { "n", "x" },
          w = { name = "LSP workspace" },
        },
        D = { name = "+print for debugging", mode = { "n", "x" } },
        e = { name = "+neo-tree" },
        o = { name = "+options" },
        n = {
          name = "+nvim",
          n = { name = "+Noice" },
        },
        h = { name = "+file" },
        g = { name = "+Git", mode = { "n", "x" } },
        j = { name = "+text", mode = { "n", "x" } },
        f = { name = "+finder" },
        p = { name = "+session" },
      },
    })
    -- load cheatsheet
    require("config.keymaps.table")
  end,
}
