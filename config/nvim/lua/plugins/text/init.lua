-- local M = Util.read_specs("plugins.text", {
--   -- "mini-surround",
--   "mini-ai",
--   "nvim-surround",
--   "yanky",
--   "leap",
--   "vim-visual-multi",
--   "CamelCaseMotion",
--   "vim-textobj",
--   "nvim-ts-rainbow",
--   "nvim-ts-context-commentstring",
--   "nvim-treesitter-textobjects",
--   "splitjoin",
--   "vim-abolish",
--   "matchup",
--   "mini-move",
-- })

-- local M = Util.load_specs("text")
-- return M

local M = Util.load_specs("text")

M = Util.tbl_combine(M, {
  -- makes some plugins dot-repeatable like leap
  { "tpope/vim-repeat", event = "VeryLazy" },
})

return M
