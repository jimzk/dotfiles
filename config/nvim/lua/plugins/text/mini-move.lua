return {
  -- Better performance than self customized keymap. I use this before:
  -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua#L21
  "echasnovski/mini.move",
  event = "VeryLazy",
  opts = {
    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = {
      -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
      left = "",
      right = "",
      down = "",
      up = "",
      -- Move current line in Normal mode
      line_left = "",
      line_right = "",
      line_down = "",
      line_up = "",
    },
  },
  config = function(_, opts)
    require("mini.move").setup(opts)
    vim.defer_fn(function()
      -- local del = vim.keymap.del
      -- del({ "v" }, ">")
      -- del({ "v" }, "<")

      local map = Util.map
      map({ "n" }, ">>", "<Cmd>lua MiniMove.move_line('right')<cr>", "Move Line Right")
      map({ "n" }, "<<", "<cmd>lua MiniMove.move_line('left')<cr>", "Move Line Left")
      map({ "v" }, ">", "<Cmd>lua MiniMove.move_selection('right')<cr>", "Move Selection Right")
      map({ "v" }, "<", "<cmd>lua MiniMove.move_selection('left')<cr>", "Move Selection Left")

      -- local map_repeatable_move = Util.map_repeatable_move
      -- local move_fn = function(type, direction, opts)
      --   return function()
      --     MiniMove["move_" .. type](direction, opts)
      --   end
      -- end
      -- -- TIP: in insert mode, <C-t>/<C-d> can indent/deindent
      -- -- https://www.reddit.com/r/neovim/comments/1af1r03/comment/kkcb3dn
      -- map_repeatable_move({ "n" }, { ">", "<" }, {
      --   move_fn("line", "right"),
      --   move_fn("line", "left"),
      -- }, { "Move Line Right", "Move Line Left" })
      --
      -- map_repeatable_move({ "v" }, { ">", "<" }, {
      --   move_fn("selection", "right"),
      --   move_fn("selection", "left"),
      -- }, { "Move Line Right", "Move Line Left" })
    end, 1000)
  end,
}
