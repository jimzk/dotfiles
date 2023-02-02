return {
  -- Better quick fix
  "kevinhwang91/nvim-bqf",
  ft = "qf",
  opts = {
    -- https://github.com/kevinhwang91/nvim-bqf#function-table
    func_map = {
      drop = "o", -- jump and close qf
      open = "<cr>", -- jump but not close qf
      openc = "",
      prevfile = "K",
      nextfile = "J",
      split = "s",
      vsplit = "v",
      -- ptogglemode = "=", -- toggle preview window size
      -- pscrollorig = "-", -- scroll back original position in preview window
    },
  },
  config = function(_, opts)
    require("bqf").setup(opts)
    -- First line in qf is fix line. Make it highlight identical with other lines.
    -- https://github.com/neovim/neovim/issues/5722#issuecomment-648820525
    vim.cmd([[hi QuickFixLine cterm=bold ctermfg=none ctermbg=none guibg=none]])
    -- vim.cmd([[hi! link BqfPreviewCursor BqfPreviewRange]])
    vim.api.nvim_create_autocmd({ "FileType" }, {
      pattern = "qf",
      callback = function(options)
        local bufnr = options.buf
        -- Close qf if there is only one item
        local path = vim.fn.stdpath("config") .. "/lua/plugins/editor/nvim-bqf.lua"
        map("n", "<cr>", function()
          local count = #vim.fn.getqflist()
          require("bqf.qfwin.handler").open(count == 1)
        end, nil, { buffer = bufnr })
        -- Keymap help
        map("n", "?", function()
          vim.cmd [[silent !open https://github.com/kevinhwang91/nvim-bqf\\#function-table]]
          vim.cmd("tabnew " .. path)
        end, nil, { buffer = bufnr }
        )
      end,
    })
  end,
}
