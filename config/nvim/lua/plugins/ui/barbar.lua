-- I don't use barbar.nvim anymore. Just keep it
M = {
  "romgrk/barbar.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-lualine/lualine.nvim" },
}

M.opts = {
  -- Enable/disable animations
  animation = true,
  -- Enable/disable auto-hiding the tab bar when there is a single buffer
  auto_hide = false,
  -- Enable/disable current/total tabpages indicator (top right corner)
  tabpages = true,
  -- Enable/disable close button
  closable = false,
  -- Enables/disable clickable tabs
  --  - left-click: go to buffer
  --  - middle-click: delete buffer
  clickable = true,
  -- Enables / disables diagnostic symbols
  diagnostics = {
    -- OR `vim.diagnostic.severity`
    [vim.diagnostic.severity.ERROR] = { enabled = true, icon = "ﬀ" },
    [vim.diagnostic.severity.WARN] = { enabled = false },
    [vim.diagnostic.severity.INFO] = { enabled = false },
    [vim.diagnostic.severity.HINT] = { enabled = true },
  },
  -- Excludes buffers from the tabline
  exclude_ft = {},
  exclude_name = {
    "package.json",
    "lazy-lock.json",
  },
  hide = { extensions = true }, -- hide invisible buffer, more clean!
  -- Disable highlighting alternate buffers
  highlight_alternate = false,
  -- Enable highlighting visible buffers
  highlight_visible = true,
  -- Enable/disable icons
  -- if set to 'numbers', will show buffer index in the tabline
  -- if set to 'both', will show buffer index and icons in the tabline
  icons = true,
  -- If set, the icon color will follow its corresponding buffer
  -- highlight group. By default, the Buffer*Icon group is linked to the
  -- Buffer* group (see Highlighting below). Otherwise, it will take its
  -- default value as defined by devicons.
  icon_custom_colors = false,
  -- Configure icons on the bufferline.
  icon_separator_active = "▎",
  icon_separator_inactive = "▎",
  icon_close_tab = "",
  icon_close_tab_modified = "●",
  icon_pinned = "車",
  -- If true, new buffers will be inserted at the start/end of the list.
  -- Default is to insert after current buffer.
  insert_at_end = false,
  insert_at_start = false,
  -- Sets the maximum padding width with which to surround each tab
  maximum_padding = 1,
  -- Sets the minimum padding width with which to surround each tab
  minimum_padding = 1,
  -- Sets the maximum buffer name length.
  maximum_length = 30,
  -- If set, the letters for each buffer in buffer-pick mode will be
  -- assigned based on their name. Otherwise or in case all letters are
  -- already assigned, the behavior is to assign letters in order of
  -- usability (see order below)
  semantic_letters = true,
  -- New buffer letters are assigned in this order. This order is
  -- optimal for the qwerty keyboard layout but might need adjustement
  -- for other layouts.
  letters = "asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP",
  -- Sets the name of unnamed buffers. By default format is "[Buffer X]"
  -- where X is the buffer number. But only a static string is accepted here.
  no_name_title = nil,
}

M.config = function(_, opts)
  require("bufferline").setup(opts)
  -- override default mapping
  vim.defer_fn(function()
    map("n", "-", "<CMD>BufferPrevious<CR>", "previous buffer")
    map("n", "=", "<CMD>BufferNext<CR>", "next buffer")
    map("n", "<BS>", "<CMD>BufferClose<CR>", "delete buffer")
    map("n", "<S-BS>", "<CMD>BufferCloseAllButCurrentOrPinned<CR>", "delete all buffer")
    map("n", "<C-0>", "<CMD>BufferPick<CR>", "pick a buffer")
  end, 0)

  local set_hl = function(status, styles)
    local parts = { "", "Sign", "Mpd", "ERROR", "INFO", "WARN", "HINT" }
    for _, value in pairs(parts) do
      local hl = "Buffer" .. status .. value
      vim.cmd([[hi! ]] .. hl .. " " .. styles)
    end
  end
  set_hl("DefaultVisible", "guibg=#303446")
  set_hl("DefaultCurrent", "gui=bold guibg=#51576d")
  vim.cmd [[hi BufferDefaultCurrent guifg=#b5e395]]
end

-- -- https://github.com/romgrk/barbar.nvim#integration-with-filetree-plugins
-- local nvim_tree_events = require("nvim-tree.events")
-- local bufferline_api = require("bufferline.api")

-- local function get_tree_size()
--   return require "nvim-tree.view".View.width
-- end

-- nvim_tree_events.subscribe("TreeOpen", function()
--   bufferline_api.set_offset(get_tree_size())
-- end)

-- nvim_tree_events.subscribe("Resize", function()
--   bufferline_api.set_offset(get_tree_size())
-- end)

-- nvim_tree_events.subscribe("TreeClose", function()
--   bufferline_api.set_offset(0)
-- end)
return M
