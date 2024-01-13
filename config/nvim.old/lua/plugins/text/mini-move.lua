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
    -- map("i", "<M-h>", function() MiniMove.move_line("left") end)
    -- map("i", "<M-j>", function() MiniMove.move_line("down") end)
    -- map("i", "<M-k>", function() MiniMove.move_line("up") end)
    -- map("i", "<M-l>", function() MiniMove.move_line("right") end)
  end,
}
