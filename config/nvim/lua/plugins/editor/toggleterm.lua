local M = {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = { "<M-space>" },
}

M.opts = {
  open_mapping = [[<M-space>]],
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  direction = "horizontal", -- 'vertical' | 'horizontal' | 'tab' | 'float'
  shade_terminals = true, -- Background color
  size = function(term)
    if term.direction == "horizontal" then
      return 25
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  float_opts = {
    winblend = 20,
    width = 140,
    border = "single", -- 'single' | 'double' | 'shadow' | 'curved'
  },
}

M.init = function()
  map("n", "<M-space>", nil, "toggle terminal")
end

M.config = function(_, opts)
  require("toggleterm").setup(opts)
  -- https://github.com/akinsho/toggleterm.nvim#terminal-window-mappings
  vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "term://*toggleterm#*",
    callback = function()
      vim.wo.cursorline = false
      local opts = { buffer = true }
      map("t", "<Tab>", [[<cmd>wincmd p<cr>]], "alternative window", opts)
      map("t", "<M-space>", [[<cmd>ToggleTerm<cr>]], "toggle term", opts)
      map("n", "<BS>", [[<Nop>]], nil, opts)
      map("n", "<C-o>", [[<Nop>]], nil, opts)
      map("n", "<C-i>", [[<Nop>]], nil, opts)
    end,
  })
  -- TODO: integrate lazygit
  -- https://github.com/akinsho/toggleterm.nvim#custom-terminals
  -- TODO: copy / paste with toggle terminal
  -- ref: https://github.com/akinsho/toggleterm.nvim/pull/339
end

return M
