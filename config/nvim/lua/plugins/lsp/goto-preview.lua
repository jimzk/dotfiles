local M = {
  -- Floating windows for LSP method
  "rmagatti/goto-preview",
  dependencies = {
    "neovim/nvim-lspconfig",
  },
  -- keys = {
  -- {
  --   "<M-LeftMouse>",
  --   "<LeftMouse>:lua require('goto-preview').goto_preview_definition()<CR>",
  --   desc = "Go Definition in Float",
  -- },
  -- {
  --   "<M-RightMouse>",
  --   "<cmd>lua require('goto-preview').close_all_win()<CR>",
  --   desc = "Close All Float Definition Window",
  -- },
  -- },
  opts = {
    height = 30,
    references = {
      telescope = { hide_preview = false },
    },
    post_close_hook = function(bufnr, winnr)
      local opts = { buffer = bufnr }
      local del = vim.keymap.del
      del("n", "<C-v>", opts)
      del("n", "<C-s>", opts)
      del("n", "<C-t>", opts)
      del("n", "q", opts)
      -- map("n", "<Esc>", "<cmd>close<cr>", opts)
    end,
    post_open_hook = function(bufnr, winnr)
      vim.cmd([[normal! zz]])
      local wo = vim.wo[winnr]
      wo.relativenumber = false
      wo.scrolloff = 1
      local opts = { buffer = bufnr }
      local map = Util.map
      map("n", "<C-v>", "<cmd>wincmd L<cr>", nil, opts)
      map("n", "<C-s>", "<cmd>wincmd J<cr>", nil, opts)
      map("n", "<C-t>", "<cmd>wincmd T<cr>", nil, opts)
      map("n", "q", function()
        vim.cmd("close")
        if _G.geto_preview_recover then
          _G.geto_preview_recover()
        end
        _G.geto_preview_recover = nil
      end, nil, opts)
      -- map("n", "<Esc>", "<cmd>close<cr>", nil, opts)
    end,
  },
}

return M
