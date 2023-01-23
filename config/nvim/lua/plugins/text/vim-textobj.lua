return {
  -- Lib for vim textobj
  "kana/vim-textobj-user",
  dependencies = {
    -- https://github.com/kana/vim-textobj-user/wiki
    -- "kana/vim-textobj-entire",
    "kana/vim-textobj-line",
    "glts/vim-textobj-comment",
    "D4KU/vim-textobj-chainmember"
  },
  event = "VeryLazy",
  init = function()
    vim.g.textobj_chainmember_no_default_key_mappings = 1
    map({ "o", "x" }, "im", "<Plug>(textobj-chainmember-i)", "chain method")
    map({ "o", "x" }, "am", "<Plug>(textobj-chainmember-a)", "chain method")
  end,
}
