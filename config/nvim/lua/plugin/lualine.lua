require('lualine').setup {
  options = {
    icons_enabled = true,
    section_separators = '',
    component_separators = { left = '|', right = '|' },
    disabled_filetypes = {
      statusline = {},
      winbar = { 'help' },
    },
    ignore_focus = {},
    always_divide_middle = true,
    -- globalstatus = true, -- only one statusline at bottom
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
}

local navic = require("nvim-navic")
require('lualine').setup {
  -- tabline = {
  --   lualine_b = {
  --     { 'tabs', mode = 2, }
  --   },
  -- },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      {
        'filename',
        file_status = true, -- display file status (readonly, modified, unmaed, new)
        newfile_status = true, -- display new file status
        path = 0, -- just filename
        shorting_target = 20,
      },
      { 'diff' },
      { 'diagnostics' },
    },
    lualine_c = {},
    lualine_x = {
      -- https://github.com/rmagatti/auto-session#statusline
      -- { require('auto-session-library').current_session_name },
    },
    lualine_y = {
      -- :h 'statusline' to check vim statusline symbols
      -- another example: "Ln %l/%L, Col %c"
      function() return [[%l:%c %p%%]] end,
    },
    lualine_z = {
      function() return " " .. vim.o.shiftwidth end,
      'encoding',
      { 'filetype', colored = false },
    }
  },
  inactive_sections = { -- What to show in status line for inactive buffer
    lualine_a = {},
    lualine_b = { 'filename' },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
  },
  winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        navic.get_location,
        cond = navic.is_available,
        Color = "ModMsg",
      },
    },
    lualine_x = {
      -- https://github.com/SmiteshP/nvim-navic#lualine
      {
        "require'lsp-status'.status()",
        separator = '', -- Component separator
      },
      {
        'branch',
        -- Other choices: #0db9d7, 74
        -- color = { fg = 117 },
      },
    },
    lualine_y = {},
    lualine_z = {}
  },
  inactive_winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
  },
  extensions = { "nvim-tree", "toggleterm", "quickfix", "fugitive", "symbols-outline" }
}

require("lualine").setup {
  options = {
    theme = 'jellybeans',
  }
}

-- Set same background color with editor zone
vim.cmd [[au ColorScheme * hi! link lualine_c_inactive Normal]]
vim.cmd [[au ColorScheme * hi! link lualine_c_normal Normal]]
vim.cmd [[au ColorScheme * hi! link lualine_c_insert Normal]]
vim.cmd [[au ColorScheme * hi! link lualine_c_visual Normal]]
vim.cmd [[au ColorScheme * hi! link lualine_c_replace Normal]]
vim.cmd [[au ColorScheme * hi! link lualine_c_command Normal]]
