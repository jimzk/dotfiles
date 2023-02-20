return {
  -- Better performance than self customized keymap. I use this before:
  -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua#L21
  "echasnovski/mini.move",
  event = "VeryLazy",
  opts = {
    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = {
      -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
      left = "<M-h>",
      right = "<M-l>",
      down = "<M-j>",
      up = "<M-k>",
      -- Move current line in Normal mode
      line_left = "<M-h>",
      line_right = "<M-l>",
      line_down = "<M-j>",
      line_up = "<M-k>",
    },
  },
  config = function(_, opts)
    require("mini.move").setup(opts)
    -- More keymap in insert mode
    -- map("i", "<M-j>", "<cmd>m .+1<cr>", "Move line down")
    -- map("i", "<M-k>", "<cmd>m .-2<cr>", "Move line up")
    -- map("i", "<M-h>", "<cmd>lua MiniMove.move_line('left')<cr>", "Move line left")
    -- map("i", "<M-l>", "<cmd>lua MiniMove.move_line('right')<cr>", "Move line right")
  end,
}
