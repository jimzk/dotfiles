return {
  "mbbill/undotree",
  keys = {
    { "<leader>ju", "<cmd>UndotreeToggle<cr>", desc = "undotree history (undotree)" },
  },
  init = function()
    --  https://github.com/mbbill/undotree
    vim.g.undotree_SplitWidth = 45 -- windows width
    vim.g.undotree_DiffpanelHeight = 20 -- diff window height
    vim.g.undotree_SetFocusWhenToggle = 1 -- focus undotree window after opened
  end,
  config = false, -- vim script plugin
}
