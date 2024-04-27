return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  keys = {
    { mode = "i", "<M-i>", "<CMD>Copilot panel<CR>", desc = "[copilot] open panel" },
  },
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = "<C-CR>",
        accept_word = "<C-M-CR>",
        accept_line = false,
        next = "<M-n>",
        prev = "<M-p>",
        dismiss = "<M-c>",
      },
    },
    panel = {
      enabled = true,
      keymap = {
        jump_next = "<M-n>",
        jump_prev = "<M-p>",
        accept = "<CR>",
        refresh = "r",
        open = false,
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
