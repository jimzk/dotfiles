local wk = require("which-key")

wk.setup {
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    -- disable most presets and set my customized keymap
    -- https://github.com/folke/which-key.nvim/blob/main/lua/which-key/plugins/presets/init.lua
    presets = {
      operators = true,
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
    gc = "comment",  -- vim-commentary
    ys = "add surrounding breackets or quotes"
  },
  window = {
    border = "single", -- none, single, double, shadow
  },
  layout = {
    height = { min = 5, max = 80 }, -- min and max height of the columns
  },
  show_help = false, -- not show help message on the command line when the popup is visible
}
