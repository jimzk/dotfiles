return {
  -- Pin buffer to window so it doesn't get replaced.
  -- Useful for plugins like neo-tree, neogit and so on.
  "stevearc/stickybuf.nvim",
  event = "BufRead",
  opts = {},
}
