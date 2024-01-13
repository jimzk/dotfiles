return {
  "stevearc/aerial.nvim",
  cmd = { "AerialToggle", "AerialOpen" },
  init = function()
    map("n", "go", "<cmd>AerialOpen<CR>", "[C] outline")
  end,
  opts = {
    layout = {
      max_width = { 60, 0.35 },
      min_width = 20,
      default_direction = "right",
    },
    keymaps = {
      ["g?"] = false,
      ["p"] = false,
      ["o"] = "actions.scroll",
      ["O"] = false,
      ["<C-j>"] = false,
      ["<C-k>"] = false,
      ["J"] = "actions.down_and_scroll",
      ["K"] = "actions.up_and_scroll",
    },
    highlight_mode = "full_width",
    highlight_on_hover = true,
    highlight_on_jump = 300,
    show_guides = true,
  }
}
