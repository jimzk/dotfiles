-- Override:
-- https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/plugins/ui.lua#L59
return {
  "akinsho/bufferline.nvim",
  enabled = false,
  opts = function()
    return {
      options = {
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
        max_name_length = 20,
        -- max_prefix_length = 0, -- prefix used when a buffer is de-duplicated
        tab_size = 0,
        show_buffer_close_icons = false,
        show_close_icon = true,
        show_tab_indicators = true,
        always_show_bufferline = true,

        -- NOTE: Experimental. this function is called frequently so keep it fast!
        custom_filter = function(buf_number, buf_numbers)
          local buf_relative_path = vim.fn.fnamemodify(vim.fn.bufname(buf_number), ":~:.")
          local items = require("harpoon"):list().items
          for _, item in ipairs(items) do
            if item.value == buf_relative_path then
              return true
            end
          end
          return false
        end,
        sort_by = function(buf_a, buf_b)
          local idx_a, idx_b = nil, nil
          local buf_a_relative_path = vim.fn.fnamemodify(vim.fn.bufname(buf_a.id), ":~:.")
          local buf_b_relative_path = vim.fn.fnamemodify(vim.fn.bufname(buf_b.id), ":~:.")
          local items = require("harpoon"):list().items
          for i, item in ipairs(items) do
            if item.value == buf_a_relative_path then
              idx_a = i
            end
            if item.value == buf_b_relative_path then
              idx_b = i
            end
          end
          return idx_a < idx_b
        end,
        name_formatter = function(buf) -- buf contains:
          local buf_relative_path = vim.fn.fnamemodify(vim.fn.bufname(buf.bufnr), ":~:.")
          local items = require("harpoon"):list().items
          for i, item in ipairs(items) do
            if item.value == buf_relative_path then
              return tostring(i) .. " " .. buf.name
            end
          end
          return "?"
        end,
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
    }
  end,
}
