-- Template:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/coding/yanky.lua
return {
  "gbprod/yanky.nvim",
  dependencies = { "kkharji/sqlite.lua" },
  event = "VeryLazy",
  opts = {
    -- yanky highlight is very laggy
    highlight = {
      on_put = false,
      on_yank = false,
    },
    textobj = {
      enabled = true,
    },
  },
  keys = function()
    local yanky = require("yanky")
    -- -- stylua: ignore
    -- local next_yank, prev_yank = Util.make_repeatable_move_pair(
    --   -- call :map <Plug>(YankyPreviousEntry) and check doc to see what the inner lua code is
    --   function() yanky.cycle(1) end,
    --   function() yanky.cycle(-1) end
    -- )
    --
    -- local _put = yanky.put
    -- yanky.put = function(...)
    --   local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
    --   ts_repeat_move.set_last_move(next_yank, { forward = true })
    --   _put(...)
    -- end

    return {
      { "iy", mode = { "o", "x" }, require("yanky.textobj").last_put, desc = "Last Put Text" },
      { "ay", "iy", mode = { "o", "x" }, desc = "Last Put Text", remap = true },

      -- stylua: ignore start
      -- { "<M-h>", function() yanky.cycle(1) end, "Cycle Prev Yank", },
      -- { "<M-l>", function() yanky.cycle(-1) end, "Cycle Next Yank", },
      -- stylua: ignore end
      -- { "]k", next_yank },
      -- { "[k", prev_yank },

      {
        "<M-y>",
        mode = { "n", "x", "i" },
        function()
          local themes = require("telescope.themes")
          require("telescope").extensions.yank_history.yank_history(themes.get_cursor({
            previewer = true,
            layout_strategy = "vertical",
            layout_config = {
              preview_height = 0.1,
              width = { 0.35, min = 80 },
              height = 0.5,
            },
          }))
        end,
        desc = "Open Yank History",
      },

      { "y", "<Plug>(YankyYank)", mode = { "n", "x" } },
      { "Y", "<Plug>(YankyYank)$", mode = { "n", "x" } },

      { "p", "<Plug>(YankyPutAfter)", desc = "which_key_ignore" },
      {
        "p",
        mode = "x",
        function()
          local mode = vim.fn.mode()
          return mode == "V" and "<Plug>(YankyPutIndentAfterLinewise)" or "<Plug>(YankyPutAfterCharwise)"
        end,
        expr = true,
      },
      { "P", "<Plug>(YankyPutBefore)", desc = "which_key_ignore" },
      {
        "P",
        mode = "x",
        function()
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

      { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put After Cursor (Linewise)" },
      { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Before Cursor (Linewise)" },

      { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and Indent Right" },
      { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and Indent Left" },
      { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put before and Indent Right" },
      { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put before and Indent Left" },
      -- { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put after applying a filter" },
      -- { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put before applying a filter" },
    }
  end,
}
