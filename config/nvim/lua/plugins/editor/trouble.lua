-- better diagnostics list and others
return {
  "folke/trouble.nvim",
  cmd = { "TroubleToggle", "Trouble" },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    group = true,
    position = "bottom",
    height = 15,
    padding = false,
    action_keys = {
      open_split = "s",
      open_vsplit = "v",
      open_tab = "t",
      toggle_preview = "P",
      preview = "p",
      help = "?",
      jump = "<cr>",
    },
    auto_preview = false,
    auto_jump = { "lsp_definitions", "lsp_type_definitions", "lsp_implementations" },
  },
}
