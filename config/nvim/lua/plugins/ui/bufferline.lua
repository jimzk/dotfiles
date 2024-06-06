local M = {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
}

M.keys = function()
  return {}
end

M.opts = {}

M.opts.options = {
  max_name_length = 20,
  -- max_prefix_length = 0, -- prefix used when a buffer is de-duplicated
  tab_size = 0,
  show_buffer_close_icons = true,
  show_close_icon = false,
  show_tab_indicators = true,
  always_show_bufferline = true,
  -- auto_toggle_bufferline = true,
  custom_filter = function(bufnr, bufnrs)
    if Util.is_buffer_visible(bufnr) then
      return true
    end
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    -- TODO: filter unchanged

    -- local diff = vim.fn.system("git diff --name-only " .. bufname)
    -- if #diff > 0 then
    --   return true
    -- end
    return true
  end,
  sort_by = "insert_after_current",
  -- style_preset = {
  --   require("bufferline").style_preset.no_italic,
  --   require("bufferline").style_preset.no_bold,
  --   require("bufferline").style_preset.minimal,
  -- },
  separator_style = { "", "" },
  indicator = {
    icon = "",
    style = "none",
  },
}

M.opts.highlights = {
  tab_selected = {
    fg = "#cad3f6",
    bg = "#494d65",
  },
}

local underline_selected = false
local set_color = function(prefix, fg, set_default)
  local postfixes = { "_selected", "_visible" }
  for _, postfix in pairs(postfixes) do
    M.opts.highlights[prefix .. postfix] = {
      fg = fg,
      bg = (not underline_selected and postfix == "_selected" and "#494d65" or ""),
      -- bold = (postfix == "_selected" and true or false),
    }
  end
end

local highlights =
  { "buffer", "numbers", "close_button", "indicator", "duplicate", "separator", "error", "warning", "hint", "info" }

for _, highlight in pairs(highlights) do
  set_color(highlight, "#cad3f6")
end
-- Color from DiagnosticSign..
set_color("error_diagnostic", "#ed8797")
set_color("warning_diagnostic", "#eed4a0")
set_color("hint_diagnostic", "#91d7e4")
set_color("info_diagnostic", "#8bd5cb")
set_color("modified", "#a6da96")
set_color("pick", "#ed8797")

-- Add underline
-- if underline_selected then
--   M.opts.options.get_element_icon = function(element)
--     local icon, hl = require("nvim-web-devicons").get_icon_by_filetype(element.filetype, { default = false })
--     if hl then
--       vim.defer_fn(function()
--         vim.cmd("hi! BufferLine" .. hl .. "Selected gui=underline, guisp=#ed8797")
--       end, 10)
--     end
--     return icon, hl
--   end
--   vim.defer_fn(function()
--     local highlights =
--       { "buffer", "numbers", "closeButton", "indicator", "duplicate", "separator", "error", "warning", "hint", "info" }
--
--     for _, highlight in pairs(highlights) do
--       vim.cmd("hi! BufferLine" .. highlight .. "Selected gui=underline guisp=#ed8797")
--     end
--   end, 1000)
-- end
--
-- vim.defer_fn(function()
--   local map = Util.map
--   -- Buffers
--   map("n", "-", "<CMD>BufferLineCyclePrev<CR>", "Previous Buffer")
--   map("n", "=", "<CMD>BufferLineCycleNext<CR>", "Next Buffer")
--   -- Move buffers
--   map("n", "<M-->", "<CMD>BufferLineMovePrev<CR>", "Move Buffer to Previous")
--   map("n", "<M-=>", "<CMD>BufferLineMoveNext<CR>", "Move Buffer to Next")
--
--   -- Remove buffers
--   local close_all_but_visible_or_pinned = function()
--     local components = require("bufferline.state").components
--     local bd = require("mini.bufremove").delete
--     for _, item in ipairs(components) do
--       if not (item:visible() or item.group == "pinned") then
--         bd(item.id)
--       end
--     end
--     require("bufferline.ui").refresh()
--   end
--   map("n", "<C-b>o", close_all_but_visible_or_pinned, "Delete Other Buffers")
--   map("n", "<C-b>d", "<CMD>BufferLinePickClose<CR>", "Delete Buffer by Pick")
--   map("n", "<C-b>D", "<Cmd>BufferLineGroupClose ungrouped<CR>", "Delete Ungroupped Buffers")
--   map("n", "<C-b>l", "<CMD>BufferLineCloseLeft<CR>", "Delete Buffers Left")
--   map("n", "<C-b>r", "<CMD>BufferLineCloseRight<CR>", "Delete Buffers Right")
--
--   -- Utilities
--   -- map("n", "<C-b>t", "<CMD>BufferRestore<CR>", "Restore Buffer")
--   map("n", "<C-b>b", "<CMD>BufferLinePick<CR>", "Pick Buffer")
--   -- Pin buffer
--   map("n", "<C-b>p", function()
--     vim.cmd("BufferLineTogglePin")
--     vim.cmd("Hbac toggle_pin")
--     require("notify").dismiss({ silent = true, pending = false })
--   end, "Pin Buffer")
--
--   map("n", "<C-t>r", ":BufferLineTabRename ", "Rename Tab")
--
--   -- Order
--   -- map("n", "<C-b>st", "<CMD>BufferLineSortByTabs<CR>", "Order by Tab")
--   -- map("n", "<C-b>sd", "<CMD>BufferLineSortByDirectory<CR>", "Order by Directory")
--   -- map("n", "<C-b>sD", "<CMD>BufferLineSortByRelativeDirectory<CR>", "Order by Relative Directory")
--   -- map("n", "<C-b>se", "<CMD>BufferLineSortByExtension<CR>", "Order by Extension")
--
--   require("which-key").register({
--     ["<C-b>"] = {
--       name = "tabline",
--       -- s = { name = "order tabline" },
--     },
--   })
-- end, 1000)

return M
