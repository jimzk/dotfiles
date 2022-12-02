require("trouble").setup {
  position = "bottom",
  height = 15,
  padding = false,
  -- FIX: can't jump back after selecting items
  -- https://github.com/folke/trouble.nvim/issues/143#issuecomment-1281771551 is a workaround
  -- https://github.com/folke/trouble.nvim/issues/235
  auto_jump = {"lsp_definitions", "lsp_type_definitions", "lsp_implementations"},
}
