return {
  "andymass/vim-matchup",
  event = "VeryLazy",
  keys = function()
    -- Get command from :map <Plug>(matchup-[%)
    -- See: https://www.reddit.com/r/neovim/comments/17x8tso/comment/k9ly2e4
    local next_bracket_repeat, prev_bracket_repeat = Util.make_repeatable_move_pair(function()
      vim.fn["matchup#motion#find_unmatched"](0, 1)
    end, function()
      vim.fn["matchup#motion#find_unmatched"](0, 0)
    end)
    return {
      -- NOTE: % keymaps work only when disabling matchit
      { "%", "<Plug>(matchup-%)", mode = { "n", "o", "x" } },
      -- { "'", "<Plug>(matchup-%)", mode = { "n", "o", "x" }, desc = "%" },
      -- { "i`", "<Plug>(matchup-z%)", mode = { "o", "x" }, desc = "Select to Function Call End" },
      { "ib", "<Plug>(matchup-i%)", mode = { "o", "x" }, desc = "(...), [...], {...}" },
      { "ab", "<Plug>(matchup-a%)", mode = { "o", "x" }, desc = "(...), [...], {...}" },
      -- { "]b", next_bracket_repeat, mode = { "n", "x", "o" }, desc = "Next Unmatched Bracket" },
      -- { "[b", prev_bracket_repeat, mode = { "n", "x", "o" }, desc = "Prev Unmatched Bracket" },
      { "]%", "<Plug>(matchup-]%)", mode = { "n", "x" }, desc = "Next Unmatched Bracket" },
      { "[%", "<plug>(matchup-[%)", mode = { "n", "x" }, desc = "Next Unmatched Bracket" },
    }
  end,
  init = function()
    vim.g.matchup_mappings_enabled = 0
    -- vim.g.matchup_matchparen_offscreen = { method = 'popup' }
    vim.g.matchup_matchparen_enabled = 1
    -- highlight matching pairs
    vim.g.matchup_matchparen_deferred = 1
    vim.g.matchup_matchparen_hi_surround_always = 0
    -- highlight background surrounded by matching pairs
    vim.g.matchup_matchparen_hi_background = 0 -- A bit annoying
  end,
  config = function()
    local treesitter_opts = {
      matchup = {
        enable = true, -- mandatory, false will disable the whole extension
        disable_virtual_text = false,
      },
    }
    require("nvim-treesitter.configs").setup(treesitter_opts)
    vim.defer_fn(function()
      vim.cmd([[
        hi! link MatchBackground DiffText
        hi! MatchParen guibg=#626787
        hi! MatchParenCur gui=none
        hi! MatchWord guibg=#626787
        " hi! MatchWordCur gui=none
      ]])
    end, 1000)
  end,
}
