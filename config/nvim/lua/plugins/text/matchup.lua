return {
  "andymass/vim-matchup",
  event = "VeryLazy",
  keys = {
    { "%", "<Plug>(matchup-%)", mode = { "n", "o", "x" }, desc = "which_key_ignore" },
    -- { "\\", "<Plug>(matchup-%)", mode = { "n", "o", "x" }, desc = "%" },
    { "<C-m>", "<Plug>(matchup-z%)", mode = { "n", "o", "x" }, desc = "move to function start" },
    { "ib", "<Plug>(matchup-i%)", mode = { "o", "x" }, desc = "{}, (), [] or syntax block" },
    { "ab", "<Plug>(matchup-a%)", mode = { "o", "x" }, desc = "{}, (), [] or syntax block" },
    { "]b", "<Plug>(matchup-]%)", mode = { "n", "o", "x" }, desc = "next unmatched } ) ]" },
    { "[b", "<Plug>(matchup-[%)", mode = { "n", "o", "x" }, desc = "prev unmatched { ( [" },
  },
  config = function()
    vim.g.matchup_mappings_enabled = 0
    -- vim.g.matchup_matchparen_offscreen = { method = 'popup' }
    vim.g.matchup_matchparen_enabled = 1
    -- highlight matching pairs
    vim.g.matchup_matchparen_deferred = 1
    vim.g.matchup_matchparen_hi_surround_always = 1
    -- highlight background surrounded by matching pairs
    vim.g.matchup_matchparen_hi_background = 1
    require("nvim-treesitter.configs").setup({
      matchup = {
        enable = true, -- mandatory, false will disable the whole extension
        disable_virtual_text = false,
      },
    })
  end,
}
