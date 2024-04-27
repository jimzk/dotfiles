local M = {
  "folke/flash.nvim",
}

M.keys = function()
  return {
    -- { "<Tab>", mode = { "n", "x", "o" }, methods.two_char_jump, desc = "Jump (Flash)" },
    {
      "<Tab>",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump({
          autojump = false,
        })
      end,
      desc = "Jump (Flash)",
    },
    {
      "R",
      mode = { "o" },
      function()
        require("flash").remote()
      end,
      desc = "Remote (Flash)",
    },
    {
      "r",
      mode = { "o", "x" },
      function()
        require("flash").treesitter_search({
          label = { rainbow = { enabled = true } },
        })
      end,
      desc = "Treesitter Search (Flash)",
    },
    {
      "<CR>",
      mode = { "n", "o", "x" },
      function()
        require("flash").treesitter({
          label = { rainbow = { enabled = true } },
        })
      end,
      desc = "Treesitter Scope (Flash)",
    },

    -- {
    --   "<CR>",
    --   mode = { "n", "o", "x" },
    --   function()
    --     methods.treesitter_remote({
    --       search = { multi_window = true },
    --     })
    --   end,
    --   desc = "Treesitter Remote (Flash)",
    -- },

    {
      "<leader>o/",
      mode = { "n" },
      function()
        require("flash").toggle()
      end,
      desc = "Toggle Search (Flash)",
    },
    {
      "g<C-d>",
      mode = { "n" },
      function()
        local methods = require("plugins.text.flash.methods")
        methods.peek_definition()
      end,
      desc = "Peek Definition Remotely (Flash)",
    },
    {
      "<leader>d<Tab>",
      mode = { "n", "x" },
      function()
        local methods = require("plugins.text.flash.methods")
        methods.peek_diagnostics({
          label = {
            after = false,
            -- before = true,
            before = { 0, 0 }, -- label on first char
            rainbow = {
              enabled = true,
            },
          },
          search = { max_length = 0 },
          highlight = {
            groups = {
              current = "",
              match = "",
            },
          },
        })
      end,
      desc = "Peek Diagnostics Remotely (Flash)",
    },
  }
end

M.opts = {
  -- labels = "dfghjklqwertyuiopcvbnm90",
  highlight = {
    -- Highlight the mated text
    groups = {
      match = "FlashCurrent",
      current = "FlashCurrent", -- Thr first matched
    },
  },
  jump = {
    inclusive = false,
  },
  modes = {
    search = {
      enabled = true,
    },
    char = {
      keys = { "f", "F" },
      -- autohide = false,
      config = function(opts)
        -- autohide flash when in operator-pending mode
        opts.autohide = opts.autohide or (vim.fn.mode(true):find("no") and vim.v.operator == "y")
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
}

return M
