local M = {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { "<M-space>",   desc = "toggle terminal" },
    { "<S-M-space>", "<cmd>ToggleTermToggleAll<cr>", mode = { "n", "t" }, desc = "toggle all terminal" },
  },
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
      return vim.opts.columns * 0.4
    end
  end,
  float_opts = {
    winblend = 20,
    width = 140,
    border = "single", -- 'single' | 'double' | 'shadow' | 'curved'
  },
}

M.config = function(_, opts)
  require("toggleterm").setup(opts)
  -- https://github.com/akinsho/toggleterm.nvim#terminal-window-mappings
  vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "term://*toggleterm#*",
    callback = function()
      vim.wo.cursorline = false
      opts = { buffer = true }
      map("n", "<Tab>", [[<cmd>wincmd p<cr>]], "alternative window", opts)
      map("t", "<M-space>", [[<cmd>ToggleTerm<cr>]], "toggle term", opts)
      map({ "t", "n" }, "<C-S-h>", [[<Nop>]], nil, opts)
      map({ "t", "n" }, "<C-S-j>", [[<cmd>ToggleTermToggleAll<cr><cmd>ToggleTerm direction=horizontal<cr>]], nil, opts)
      map({ "t", "n" }, "<C-S-k>", [[<Nop>]], nil, opts)
      map({ "t", "n" }, "<C-S-l>", [[<cmd>ToggleTermToggleAll<cr><cmd>ToggleTerm direction=vertical<cr>]], nil, opts)
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
