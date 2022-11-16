require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    section_separators = { left = '', right = '' },
    component_separators = { left = '|', right = '|' },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      {
        'filename',
        file_status = true,  -- display file status (readonly, modified, unmaed, new)
        newfile_status = true,  -- display new file status
        path = 0, -- just filename
        shorting_target = 20,
      },
      'diagnostics',
      'diff',
    },
    lualine_c = {
      function() return [[Ln %l/%L, Col %c]] end,
    },
    lualine_x = {
      require('auto-session-library').current_session_name,
    },
    lualine_y = {
      -- function() return "indent " .. vim.o.softtabstop end,
      'encoding',
      'filetype'
    },
    lualine_z = {
      'branch',
      -- TODO: lsp-status
      -- "require'lsp-status'.status()"
    }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = {},
    lualine_y = {
      'encoding',
      'filetype'
    },
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
