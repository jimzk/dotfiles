return {
  -- Coding with ChatGPT
  "jackMort/ChatGPT.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim"
  },
  keys = {
    { "<leader>t", "<cmd>ChatGPT<cr>", desc = "ChatGPT" },
    { "<leader><C-t>", "<cmd>ChatGPTActAs<cr>", desc = "ChatGPT with awesome prompt" },
    -- <C-y> apply changes, <C-i> use as input.
    -- https://www.youtube.com/watch?v=dWe01EV0q3Q
    { "<leader>T", "<cmd>ChatGPTEditWithInstructions<cr>", mode = { "x", "n" }, desc = "ChatGPT with code" },
  },
  opts = {
    keymaps = {
      scroll_up = "<C-b>",
      scroll_down = "<C-f>",
    }
  }
}
