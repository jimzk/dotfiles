-- Killer feature:
-- * Tresitter node selection
-- * Remote search and operate
-- * Compared to flit.nvim, f/F findings won't disappear after moving forward.
-- Cons:
-- * f/F/t/T in operator pending mode will apply the first match immediately. I hope it can show labels for choosing.
-- * n/N to ge the next and previous doesn't work in f/F/t/T search event if I config.
--
return {
  "folke/flash.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<Tab>",
      mode = { "n", "x", "o" },
      function() require("flash").jump() end,
      desc = "jump (flash)",
    },
    -- { -- TODO: implement
    --   "f<Tab>",
    --   mode = { "n", "x", "o" },
    --   function()
    --     require("flash").jump({
    --       search = {
    --         mode = function(str) return "\\<" .. str end,
    --       },
    --     })
    --   end,
    --   desc = "jump to ( { [ (",
    -- },
    {
      "so",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump({
          action = function(match, state)
            vim.api.nvim_win_call(match.win, function()
              vim.api.nvim_win_set_cursor(match.win, match.pos)
              vim.diagnostic.open_float()
            end)
            state:restore()
          end,
        })
      end,
      desc = "old jump (flash)",
    },
    {
      "R",
      mode = { "o", "x" },
      function() require("flash").treesitter() end,
      desc = "treesitter (flash)",
    },
    {
      "r",
      mode = { "o", "x" },
      function() require("flash").treesitter_search() end,
      desc = "treesitter search (flash)",
    },
    -- {
    --   "<leader><c-space>",
    --   mode = { "o" },
    --   function() require("flash").remote() end,
    --   desc = "operate remotely (flash)",
    -- },
    {
      "<leader>os",
      mode = { "n" },
      function() require("flash").toggle() end,
      desc = "toggle search (flash)",
    },
  },
  opts = {
    highlight = {
      -- Highlight the mated text
      -- matches = false,
      groups = {
        match = "FlashCurrent",
        current = "FlashCurrent",
      },
    },
    label = {
      after = false,
      before = { 0, 0 }, -- relative to the match
      rainbow = {
        enabled = true,
        -- number between 1 and 9
        shade = 5,
      },
    },
    jump = {
      inclusive = false,
    },
    modes = {
      search = {
        enabled = false,
      },
      char = {
        keys = { "f", "F" },
        -- autohide = false,
        config = function(opts)
          -- autohide flash when in operator-pending mode
          opts.autohide = vim.fn.mode(true):find("no") and vim.v.operator == "y"
          -- Show jump labels only in operator-pending mode
          opts.jump_labels = vim.v.count == 0 and vim.fn.mode(true):find("o")
        end,
        label = {
          rainbow = {
            enabled = false,
          },
        },
      },
    },
  },
}
