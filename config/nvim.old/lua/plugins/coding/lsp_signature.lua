return {
  "ray-x/lsp_signature.nvim",
  event = "VeryLazy",
  dependencies = {
    "neovim/nvim-lspconfig",
  },
  opts = {
    max_height = 35,
    bind = true,
    handler_opts = {
      border = "rounded",
    },
    hi_parameter = "Cursor",
    floating_window = false, -- No automatically show signature on cursor
    floating_window_above_cur_line = true,
    toggle_key = "<C-space>",    
  },
}
