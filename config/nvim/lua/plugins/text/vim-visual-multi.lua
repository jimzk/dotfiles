return {
  "mg979/vim-visual-multi",
  event = "VeryLazy",
  init = function()
    map({ "n", "v" }, "<C-n>", nil, "multi select next")
    map("n", "<M-n>", "<Plug>(VM-Add-Cursor-Down)", "multi select down")
    map("n", "<M-S-n>", "<Plug>(VM-Add-Cursor-Up)", "multi select up")
    map("n", "<S-up>", "<Plug>(VM-Select-Cursor-Up)", "visual up")
    map("n", "<S-down>", "<Plug>(VM-Select-Cursor-Down)", "which_key_ignore")
    map("n", "<S-left>", "<Plug>(VM-Select-h)", "which_key_ignore")
    map("n", "<S-right>", "<Plug>(VM-Select-l)", "which_key_ignore")
    -- Help: :h vm-highlight
    vim.g.VM_Mono_hl = "Cursor" -- All cursors
    vim.g.VM_Cursor_hl = "Cursor" -- Cursor in selection
    vim.g.VM_Extend_hl = "CurSearch" -- Selected items in selection
    -- vim.g.VM_Insert_hl = 'IncSearch' -- Multi insert place atfer selection
    vim.g.VM_leader = ",,"
  end,
}
