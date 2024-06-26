local M = {
  -- Better quick fix
  "kevinhwang91/nvim-bqf",
  ft = "qf",
}

M.opts = {
  -- https://github.com/kevinhwang91/nvim-bqf#function-table
  auto_resize_height = false,
  func_map = {
    drop = "o", -- jump and close qf
    open = "<cr>", -- jump but not close qf
    openc = "",
    prevfile = "K",
    nextfile = "J",
    prevhist = "<M-h>",
    nexthist = "<M-l>",
    split = "s",
    vsplit = "v",
    pscrollup = "<M-k>",
    pscrolldown = "<M-j>",
    ptogglemode = "<C-p>",
    -- ptogglemode = "=", -- toggle preview window size
    -- pscrollorig = "-", -- scroll back original position in preview window
  },
  -- Adapt fzf's delimiter in nvim-bqf
  -- https://github.com/kevinhwang91/nvim-bqf#format-new-quickfix
  filter = {
    fzf = {
      extra_opts = { "--bind", "ctrl-o:toggle-all", "--delimiter", "│" },
    },
  },
}

M.config = function(_, opts)
  require("bqf").setup(opts)
  -- First line in qf is fixed line. Make it highlight identical with other lines.
  -- https://github.com/neovim/neovim/issues/5722#issuecomment-648820525
  -- vim.cmd([[hi QuickFixLine cterm=bold ctermfg=none ctermbg=none guibg=none]])

  -- vim.cmd([[hi! link BqfPreviewCursor BqfPreviewRange]])
  local map = Util.map
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
        vim.cmd([[silent !open https://github.com/kevinhwang91/nvim-bqf\\#function-table]])
        vim.cmd("tabnew " .. path)
      end, nil, { buffer = bufnr })
    end,
  })
end

return M
