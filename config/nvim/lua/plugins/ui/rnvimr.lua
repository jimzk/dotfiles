return {
  "kevinhwang91/rnvimr",
  event = "VeryLazy",
  keys = {
    { "<M-r>", "<CMD>RnvimrToggle<CR>", desc = "Ranger" },
    { mode = "t", "<M-r>", "<C-\\><C-n><CMD>RnvimrToggle<CR>", desc = "Close Ranger" },
    { mode = "t", "<M-i>", "<C-\\><C-n><CMD>RnvimrResize<CR>", desc = "Change Ranger Layout" },
  },
  config = function()
    -- Replace netrw
    vim.g.rnvimr_enable_ex = 1
    -- Hidden after picking a file
    vim.g.rnvimr_enable_picker = 1
    -- Disable a border for floating window
    -- vim.g.rnvimr_draw_border = 0
    -- Hide the files included in gitignore
    -- vim.g.rnvimr_hide_gitignore = 1

    -- https://github.com/ranger/ranger/wiki/Official-user-guide#key-bindings-and-hints-
    vim.g.rnvimr_action = {
      ["<C-t>"] = "NvimEdit tabedit",
      ["<C-s>"] = "NvimEdit split",
      -- BUG: in macOS <C-v> work only when pressing twice
      -- https://github.com/kevinhwang91/rnvimr/issues/122
      ["<C-v>"] = "NvimEdit vsplit",
      ["_"] = "NvimEdit split",
      ["|"] = "NvimEdit vsplit",
      ["<Esc>"] = "quit",
      ["gw"] = "JumpNvimCwd",
      ["yw"] = "EmitRangerCwd",

      ["e"] = "edit",
      ["<CR>"] = "edit",
    }
  end,
}
