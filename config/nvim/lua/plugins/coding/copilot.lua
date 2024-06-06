return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  keys = {
    { mode = { "i", "n", "x" }, "<C-M-Cr>", "<CMD>Copilot panel<CR>", desc = "[copilot] open panel" },
  },
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = false,
        accept_word = "<C-l>",
        accept_line = "<C-S-l>",
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<M-\\>",
      },
    },
    panel = {
      enabled = true,
      keymap = {
        jump_next = "<M-]>",
        jump_prev = "<M-[>",
        accept = "<CR>",
        refresh = "r",
        open = "<M-CR>",
      },
      layout = {
        position = "left", -- | top | left | right
        ratio = 0.3,
      },
    },
    filetypes = {
      markdown = true,
      help = true,
    },
  },
  config = function(_, opts)
    require("copilot").setup(opts)
    -- local cmp = require("cmp")
    -- cmp.event:on("menu_opened", function()
    --   vim.b.copilot_suggestion_hidden = true
    -- end)
    -- cmp.event:on("menu_closed", function()
    --   vim.b.copilot_suggestion_hidden = false
    -- end)
  end,
}
