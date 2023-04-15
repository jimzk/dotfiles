return {
  "aserowy/tmux.nvim",
  -- Know issue in Tmux
  --   - <C-S-*> works the same as <C-*>
  --   - <C-i> and <Tab>, <C-[> and <Esc> can not be distinguished.
  event = "VeryLazy",
  opts = {
    navigation = {
      enable_default_keybindings = false,
    },
    resize = {
      enable_default_keybindings = false,
    }
  },
  config = function(_, opts)
    local tmux = require("tmux")
    tmux.setup(opts)
    -- Lazy map to overwrite keymap in config/keymaps
    vim.defer_fn(function()
      map("n", "<C-h>", tmux.move_left)
      map("n", "<C-j>", tmux.move_bottom)
      map("n", "<C-k>", tmux.move_top)
      map("n", "<C-l>", tmux.move_right)
      map("n", "<C-M-h>", tmux.resize_left)
      map("n", "<C-M-j>", tmux.resize_bottom)
      map("n", "<C-M-k>", tmux.resize_top)
      map("n", "<C-M-l>", tmux.resize_right)
    end, 0)
  end
}
