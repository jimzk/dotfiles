return {
  "pocco81/true-zen.nvim", -- Zen mode
  -- enabled = true,
  keys = {
    { "<leader>z", "<cmd>TZFocus<cr>", desc = "zen mode (focus)" },
    { "<leader>Z", "<cmd>TZAtaraxis<cr>", desc = "zen mode (ataraxis)" }
  },
  opts = {
    modes = {
      focus = {
        callbacks = { -- run functions when opening/closing Focus mode
          open_pos = function()
            vim.notify("Zen mode on")
          end,
          close_pos = function()
            vim.notify("Zen mode off")
          end,
        },
      }
    },
    integrations = {
      kitty = {
        enabled = true,
        font = "+1"
      },
    }
  },
}
