local M = {
  "folke/flash.nvim",
}

M.keys = function()
  local methods = require("plugins.text.flash.methods")
  return {
    -- {
    --   "<Tab>",
    --   mode = { "n", "x", "o" },
    --   function()
    --     require("flash").jump({
    --       label = {
    --         before = true,
    --         after = false,
    --       },
    --       jump = {
    --         autojump = false,
    --       },
    --     })
    --   end,
    --   desc = "Jump (Flash)",
    -- },
    -- {
    --   "f",
    --   mode = { "n", "x", "o" },
    --   function()
    --     methods.two_char_jump()
    --   end,
    --   desc = "Jump (Flash)",
    -- },
    {
      "<C-;>",
      mode = { "n", "x", "o" },
      function()
        methods.two_char_jump([[\(^ *\)\@<=\S]])
      end,
      desc = "Jump to Line",
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
      "g<space>",
      mode = { "n" },
      function()
        methods.peek_definition()
      end,
      desc = "Peek Definition Remotely (Flash)",
    },
    {
      "<leader>d<Tab>",
      mode = { "n", "x" },
      function()
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
  search = {
    exclude = {
      "notify",
      "cmp_menu",
      "noice",
      "flash_prompt",
      "neo-tree",
      "aerial",
      function(win)
        -- exclude non-focusable windows
        return not vim.api.nvim_win_get_config(win).focusable
      end,
    },
  },
  modes = {
    search = {
      enabled = true,
    },
    char = {
      enabled = true,
      keys = { "f", "F" },
      -- autohide = true,
      jump_labels = true,
      label = {
        exclude = "hjkliardcAZTU",
        rainbow = {
          enabled = false,
        },
      },
    },
  },
}

return M
