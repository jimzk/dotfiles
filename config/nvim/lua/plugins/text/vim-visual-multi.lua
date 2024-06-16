local map = Util.map
return {
  -- Alternative:
  -- - https://github.com/otavioschwanck/cool-substitute.nvim
  "mg979/vim-visual-multi",
  event = "VeryLazy",
  init = function()
    local map = Util.map
    map({ "n", "x" }, "<C-n>", nil, "Add Word to Selection")
    map("n", "<M-S-j>", nil, "Add Cursor Down")
    map("n", "<M-S-k>", nil, "Add Cursor Up")
    -- :h vim-visual-multi
    vim.g.VM_maps = {
      ["Add Cursor Down"] = "<M-S-j>",
      ["Add Cursor Up"] = "<M-S-k>",
      -- ["VM Select Cursor Up"] = "<S-up>",
      -- ["VM Select Cursor Down"] = "<S-down>",
      -- ["VM Select h"] = "<S-left>",
      -- ["VM Select l"] = "<S-right>",
    }
    vim.g.VM_leader = "\\"
    -- vim.g.VM_default_mappings = 0

    -- Help: :h vm-highlight
    vim.g.VM_Mono_hl = "Cursor" -- All cursors
    vim.g.VM_Cursor_hl = "Cursor" -- Cursor in selection
    vim.g.VM_Extend_hl = "CurSearch" -- Selected items in selection
    -- vim.g.VM_Insert_hl = 'IncSearch' -- Multi insert place atfer selection
  end,
}
