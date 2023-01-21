return {
  "karb94/neoscroll.nvim",
  event = "BufReadPre",
  enabled = function()
    return vim.g.neovide ~= true
  end,
  opts = {
    mappings = { "<C-u>", "<C-d>", "zt", "zz", "zb" },
  },
}
