local M = {
  -- Enhanced f/F/t/T motions.
  -- Known issue: https://github.com/ggandor/flit.nvim/issues/3.
  -- Change of my repo:
  -- * support for exclude match in o/x mode
  -- * support for setting key to false.
  "fjchen7/flit.nvim",
  dependencies = {
    "ggandor/leap.nvim",
  },
  event = "VeryLazy",
}

M.opts = {
  keys = { f = "f", F = "F", t = false, T = false },
  labeled_modes = "o", -- "nvo"
  -- my option
  motion_specific_args = {
    o = {
      f = { offset = -1 },
      F = { offset = 1 },
    },
  },
}

M.config = function(_, opts)
  require("flit").setup(opts)
  vim.on_key(function(char)
    -- Cancel flit and visual mode when pressing <Esc>.
    local modes = "vV"
    if modes:match(vim.fn.mode()) then
      local keys = { "<Esc>" }
      if vim.tbl_contains(keys, vim.fn.keytrans(char)) then
        Util.feedkeys("<Esc>")()
      end
    end
  end, vim.api.nvim_create_namespace("flit"))
end

return M
