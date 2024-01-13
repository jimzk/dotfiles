return {
  -- Lib for vim textobj
  "kana/vim-textobj-user",
  dependencies = {
    "glts/vim-textobj-comment",
    "D4KU/vim-textobj-chainmember",
  },
  event = "VeryLazy",
  init = function()
    vim.g.textobj_chainmember_no_default_key_mappings = 1
    local map = require("util").map
    map({ "o", "x" }, "im", "<Plug>(textobj-chainmember-i)", "Chain Member")
    map({ "o", "x" }, "am", "<Plug>(textobj-chainmember-a)", "Chain Member")
    -- vim-textobj-comment
    vim.g.textobj_comment_no_default_key_mappings = 1
    map({ "o", "x" }, "ic", "<Plug>(textobj-comment-i)", "Comment")
    map({ "o", "x" }, "ac", "<Plug>(textobj-comment-a)", "Comment")
  end,
}
