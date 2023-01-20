return {
  "AndrewRadev/splitjoin.vim",
  event = "VeryLazy",
  init = function()
    vim.g.splitjoin_join_mapping = "J"
    -- I don't want K fallback
    vim.g.splitjoin_split_mapping = ""
    map("n", "K", "<cmd>SplitjoinSplit<cr>")
  end,
}
