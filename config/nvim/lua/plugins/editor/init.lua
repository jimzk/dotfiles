local specs = Util.load_specs("editor")

vim.list_extend(specs, {
  -- Delete buffer without messing up layout
  -- { "moll/vim-bbye", cmd = { "Bwipeout", "Bdelete" } },
  --
  -- Auto detect indent width
  { "tpope/vim-sleuth", lazy = false },
})

return specs
