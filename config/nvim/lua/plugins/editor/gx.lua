return {
  -- Enhance gx to open URL, github repo, issue ...
  "chrishrb/gx.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = { "BufEnter" },
  keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
  init = function()
    vim.g.netrw_nogx = 1 -- disable netrw gx
  end,
  opts = {},
}
