return {
  "akinsho/toggleterm.nvim",
  event = "VeryLazy",
  enabled = false,
  opts = {},
  config = function(_, opts)
    require("toggleterm").setup(opts)
    local lazygit = require("toggleterm.terminal").Terminal:new({
      cmd = "lazygit",
      dir = "git_dir",
      direction = "float",
      float_opts = {
        border = "double",
      },
      on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(term.bufnr, "t", "q", "<cmd>hide<CR>", { noremap = true, silent = true })
      end,
      on_close = function(term)
        vim.cmd("startinsert!")
      end,
    })

    function _G._lazygit_toggle()
      lazygit:toggle()
    end

    vim.api.nvim_set_keymap("n", "<M-g>", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })
  end,
}
