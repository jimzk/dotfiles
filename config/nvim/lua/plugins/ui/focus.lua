-- This plugin has too many Bugs. As far as I know
-- * :FocusMaxOrEqual can't max horizontal layout
-- * Windows of filetypes in `excluded_filetypes` will still be resized (like toggleterm)
return {
  -- Auto resize window
  "beauwilliams/focus.nvim",
  event = "VeryLazy",
  keys = {
    { "<C-\\>", "<cmd>FocusToggle<cr>", desc = "Toggle window autosize (focus)" },
    -- { "<C-=>", "<cmd>FocusMaxOrEqual<cr>", desc = "Toggle full window (focus)" },
  },
  opts = {
    -- autoresize == true messup harpoon and telescope.
    autoresize = false,
    width = 100,
    height = 40,
    -- Focus.lua will make sure window is not smaller than minwidth/minheight
    -- If there is no enough room then it will occupy toggleterm or quickfix size.
    -- Set minwidth/minheight to a small value.
    minwidth = 10,
    minheight = 5,
    -- Set focused windows's signcolumn to "yes"
    signcolumn = false,
    excluded_buftypes = { "help", "acwrite", "quifkfix", "nofile", "terminal", "prompt" },
    excluded_filetypes = { "qf", "toggleterm", "harpoon" },
    compatible_filetrees = { "neo-tree" },
  },
}
