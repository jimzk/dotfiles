return {
  -- Lib for vim textobj
  "kana/vim-textobj-user",
  dependencies = {
    {
      "glts/vim-textobj-comment",
      init = function()
        vim.g.textobj_comment_no_default_key_mappings = 1
      end,
    },
    -- {
    --   "D4KU/vim-textobj-chainmember",
    --   init = function()
    --     vim.g.textobj_chainmember_no_default_key_mappings = 1
    --   end,
    -- },
  },
  keys = {
    -- { mode = { "o", "x" }, "i.", "<Plug>(textobj-chainmember-i)", desc = "Chain Member" },
    -- { mode = { "o", "x" }, "a.", "<Plug>(textobj-chainmember-a)", desc = "Chain Member" },
    { mode = { "o", "x" }, "i\\", "<Plug>(textobj-comment-i)", desc = "Comment" },
    { mode = { "o", "x" }, "a\\", "<Plug>(textobj-comment-a)", desc = "Comment" },
  },
}
