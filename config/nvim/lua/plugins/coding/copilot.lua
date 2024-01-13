return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        -- accept = "<C-g>",
        -- next = "<M-n>",
        -- prev = "<M-p>",
        -- dismiss = "<M-c>",
      },
    },
    panel = { enabled = false },
    filetypes = {
      markdown = true,
      help = false,
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
