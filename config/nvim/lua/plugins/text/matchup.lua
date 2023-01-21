return {
  "andymass/vim-matchup",
  event = "VeryLazy",
  keys = {
    { "%", "<Plug>(matchup-%)", mode = { "n", "o", "x" } },
    { "i%", "<Plug>(matchup-i%)", mode = { "o", "x" } },
    { "a%", "<Plug>(matchup-a%)", mode = { "o", "x" } },
    { "]%", "<Plug>(matchup-]%)", mode = { "n", "o", "x" } },
    { "[%", "<Plug>(matchup-[%)", mode = { "n", "o", "x" } },

    -- aliases
    { "i;", "<Plug>(matchup-i%)", mode = { "o", "x" } },
    { "a;", "<Plug>(matchup-a%)", mode = { "o", "x" } },
    { "];", "<Plug>(matchup-]%)", mode = { "n", "o", "x" } },
    { "[;", "<Plug>(matchup-[%)", mode = { "n", "o", "x" } },
    { "<C-;>", "<Plug>(matchup-z%)", mode = { "n", "o", "x" } },
  },
  config = function()
    vim.g.matchup_mappings_enabled = 0
    -- vim.g.matchup_matchparen_offscreen = { method = 'popup' }
    vim.g.matchup_matchparen_enabled = 1
    require("nvim-treesitter.configs").setup({
      matchup = {
        enable = true, -- mandatory, false will disable the whole extension
        disable_virtual_text = false,
      },
    })
  end,
}
