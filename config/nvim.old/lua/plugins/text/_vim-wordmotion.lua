return {
  -- More fined grained word motions
  -- https://www.reddit.com/r/neovim/comments/115trxb/tabline_with_separated_buffers_how_to_achieve_this/
  "chaoren/vim-wordmotion",
  event = "VeryLazy",
  init = function()
    vim.g.wordmotion_nomap = true
    map({ "x", "o" }, "is", "<Plug>WordMotion_iw", "fine-grained iw")
    map({ "x", "o" }, "as", "<Plug>WordMotion_aw", "fine-grained aw")

    -- map({ "n", "x", "o" }, "W", "w")
    -- map({ "x", "o" }, "iW", "iw")
    -- map({ "x", "o" }, "aW", "aw")
    -- map({ "x", "o" }, "i<Space>", "iW")
    -- map({ "x", "o" }, "a<Space>", "aW")

    -- map({ "n", "x", "o" }, "E", "e")
    -- map({ "n", "x", "o" }, "B", "b")
    -- map({ "n", "x", "o" }, "gE", "ge")
  end
}
