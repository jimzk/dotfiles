return {
  -- Exchange text
  "gbprod/substitute.nvim",
  event = "VeryLazy",
  opts = {
    yank_substituted_text = false,
    preserve_cursor_position = false,
    highlight_substituted_text = {
      enabled = true,
      timer = 500,
    },
    range = {
      prefix = "s",
      prompt_current_text = false,
      confirm = false,
      complete_word = false,
      motion1 = false,
      motion2 = false,
      suffix = "",
    },
    exchange = {
      motion = false,
      use_esc_to_cancel = true,
      preserve_cursor_position = false,
    },
  },
  config = function(_, opts)
    opts.on_substitute = require("yanky.integration").substitute()
    require("substitute").setup(opts)
    -- Lua
    vim.keymap.set("n", "<C-s>", require("substitute.exchange").operator, { noremap = true })
    vim.keymap.set("n", "<C-s><C-s>", require("substitute.exchange").line, { noremap = true })
    -- vim.keymap.set("n", "|", function()
    --   require("substitute.exchange").operator({ motion = "$", })
    -- end, { noremap = true })
    vim.keymap.set("x", "<C-s>", require("substitute.exchange").visual, { noremap = true })
    vim.keymap.set("n", "<C-s>c", require("substitute.exchange").cancel, { noremap = true })
  end
}
