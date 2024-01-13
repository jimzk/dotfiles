-- Override:
-- https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/plugins/ui.lua#L59
return {
  "akinsho/bufferline.nvim",
  keys = function()
    return {
      {
        "<leader>bp",
        function()
          vim.cmd("BufferLineTogglePin")
          vim.cmd("Hbac toggle_pin")
          require("notify").dismiss({ silent = true, pending = false })
        end,
        desc = "Toggle Pin",
      },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Unpinned Buffers" },

      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },

      { "<M-i>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<M-o>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      -- { "<leader>b-", "H", desc = "Prev Buffer (H)", remap = true },
      -- { "<leader>b=", "L", desc = "Next Buffer (L)", remap = true },
      -- { "<leader>bh", "<cmd>BufferLineMovePrev<cr>", desc = "Move Buffer to Prev" },
      -- { "<leader>bl", "<cmd>BufferLineMoveNext<cr>", desc = "Move Buffer to Next" },
    }
  end,
  opts = {
    options = {
      max_name_length = 15,
      -- max_prefix_length = 0, -- prefix used when a buffer is de-duplicated
      tab_size = 0,
      show_buffer_close_icons = false,
      show_close_icon = true,
      show_tab_indicators = true,
      always_show_bufferline = false,
    },
    highlights = {
      fill = {
        bg = "",
      },
      background = {
        bg = "",
      },
      separator = {
        bg = "",
      },
    },
  },
}
