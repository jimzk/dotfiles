return {
  "rmagatti/goto-preview",
  event = "VeryLazy",
  opts = {
    default_mappings = true,
    winblend = 10,
    post_open_hook = function(bufnr, winnr)
      local buffer_num = vim.api.nvim_get_current_buf() -- current buffer
      vim.api.nvim_buf_set_option(buffer_num, "buflisted", true)
      vim.cmd([[normal! zt]])
      -- local bo = vim.bo[bufnr]
      local wo = vim.wo[winnr]
      -- bo.modifiable = false
      wo.relativenumber = false
      -- wo.signcolumn = 'no'
      wo.scrolloff = 1
      local opts = { buffer = bufnr }
      -- set("n", "v", "<cmd>wincmd L<cr>")
      vim.keymap.set("n", "v", "<cmd>wincmd L<cr>", opts)
      vim.keymap.set("n", "s", "<cmd>wincmd J<cr>", opts)
      vim.keymap.set("n", "t", "<cmd>wincmd T<cr>", opts)
      vim.keymap.set("n", "t", function() end, opts)
    end,
  },
  config = function(_, opts)
    require("goto-preview").setup(opts)
    vim.cmd([[
  nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>
  nnoremap gpt <cmd>lua require('goto-preview').goto_preview_type_definition()<CR>
  nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>
  nnoremap gpr <cmd>lua require('goto-preview').goto_preview_references()<CR>
  nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>
  ]])
  end,
}
