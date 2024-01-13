-- Template:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/coding/yanky.lua
return {
  "gbprod/yanky.nvim",
  dependencies = { { "kkharji/sqlite.lua", enabled = not jit.os:find("Windows") } },
  opts = {
    ring = { storage = jit.os:find("Windows") and "shada" or "sqlite" },
    preserve_cursor_position = {
      enabled = true,
    },
    textobj = {
      enabled = true,
    },
    -- yanky highlight is very laggy
    highlight = {
      on_put = false,
      on_yank = false,
      timer = 500,
    },
  },
  keys = function()
    local yanky = require("yanky")
    -- stylua: ignore
    local next_yank, _ = require("util").make_repeatable_move_pair(
      -- call :map <Plug>(YankyPreviousEntry) and check doc to see what the inner lua code is
      function() yanky.cycle(1) end,
      function() yanky.cycle(-1) end
    )
    local set_last_move = function()
      local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
      ts_repeat_move.set_last_move(next_yank, { forward = true })
    end
    return {
      {
        "iy",
        function()
          require("yanky.textobj").last_put()
        end,
        mode = { "o", "x" },
        desc = "Last Put Text",
      },
      { "ay", "iy", mode = { "o", "x" }, desc = "Last Put Text", remap = true },
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" } },
      { "Y", "<Plug>(YankyYank)$", mode = { "n", "x" } },

      -- {
      --   "<leader>P",
      --   function()
      --     require("telescope").extensions.yank_history.yank_history({})
      --   end,
      --   desc = "Open Yank History",
      -- },

      {
        mode = "n",
        "p",
        function()
          set_last_move()
          return "<Plug>(YankyPutAfter)"
        end,
        expr = true,
        desc = "which_key_ignore",
      },
      {
        mode = "x",
        "p", -- No yank at visual put
        function()
          set_last_move()
          -- Respect indentation in current context if selection is linewise
          local mode = vim.fn.mode()
          return mode == "V" and "<Plug>(YankyPutIndentAfterLinewise)" or "<Plug>(YankyPutAfterCharwise)"
        end,
        expr = true,
      },
      {
        mode = "n",
        "P",
        function()
          set_last_move()
          return "<Plug>(YankyPutBefore)"
        end,
        expr = true,
        desc = "which_key_ignore",
      },
      {
        mode = "x",
        "P",
        function()
          set_last_move()
          local mode = vim.fn.mode()
          return mode == "V" and "<Plug>(YankyPutIndentBeforeLinewise)" or "<Plug>(YankyPutBeforeCharwise)"
        end,
        expr = true,
        desc = "which_key_ignore",
      },

      -- { "gp", "<Plug>(YankyGPutAfter)", mode = "n", desc = "Put after Selection" },
      -- {
      --   "gp",
      --   function()
      --     local mode = vim.fn.mode()
      --     return mode == "V" and "<Plug>(YankyGPutIndentAfterLinewise)" or "<Plug>(YankyGPutAfterCharwise)"
      --   end,
      --   mode = "x",
      --   expr = true,
      -- },
      -- { "gP", "<Plug>(YankyGPutBefore)", mode = "n", desc = "Put before Selection" },
      -- {
      --   "gP",
      --   function()
      --     local mode = vim.fn.mode()
      --     return mode == "V" and "<Plug>(YankyGPutIndentBeforeLinewise)" or "<Plug>(YankyGPutBeforeCharwise)"
      --   end,
      --   mode = "x",
      --   expr = true,
      -- },

      -- I change behaviors of gp/gP - put linewise
      {
        "gp",
        function()
          set_last_move()
          return "<Plug>(YankyPutIndentAfterLinewise)"
        end,
        desc = "Put After Cursor (Linewise)",
        expr = true,
      },
      {
        "gP",
        function()
          set_last_move()
          return "<Plug>(YankyPutIndentBeforeLinewise)"
        end,
        desc = "Put Before Cursor (Linewise)",
        expr = true,
      },

      -- { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and Indent Right" },
      -- { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and Indent Left" },
      -- { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put before and Indent Right" },
      -- { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put before and Indent Left" },
      -- { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put after applying a filter" },
      -- { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put before applying a filter" },
    }
  end,
}
