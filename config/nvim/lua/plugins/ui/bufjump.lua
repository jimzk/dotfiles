-- Navigate to jump list of buffers
return {
  "kwkarlwang/bufjump.nvim",
  enabled = false,
  event = "BufReadPost",
  opts = {
    forward_key = "<C-M-i>",
    backward_key = "<C-M-o>",
  },
}
