return {
  "olimorris/persisted.nvim",
  lazy = false,
  --module = "persisted", -- For lazy loading
  config = function()
    require("persisted").setup()
    require("telescope").load_extension("persisted") -- To load the telescope extension
  end,
}
