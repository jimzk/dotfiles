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
  end,
}
