local M = {
  -- Enhanced f/F/t/T motions.
  -- Disable it as I can’t stand with the issue https://github.com/ggandor/flit.nvim/issues/3.
  "ggandor/flit.nvim",
  dependencies = {
    "ggandor/leap.nvim",
  },
  event = "VeryLazy",
}

M.opts = {
  keys = { f = "f", F = "F", t = "T", T = "T" },
  labeled_modes = "nvo",
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
        Util.feedkeys("<Esc>")
      end
    end
  end, vim.api.nvim_create_namespace("flit"))
end

return M
