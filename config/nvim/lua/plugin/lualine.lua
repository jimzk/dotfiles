local ll = require("lualine")
ll.setup {
  options = {
    icons_enabled = true,
    section_separators = '',
    component_separators = { left = '|', right = '|' },
    disabled_filetypes = {
      statusline = { "TelescopePrompt" },
      winbar = { "NvimTree", "gitcommit", "fugitive", "fugitiveblame", "untotree" },
    },
    ignore_focus = {},
    always_divide_middle = true,
    refresh = {
      statusline = 800,
      tabline = 1000,
      winbar = 1000,
    },
    globalstatus = true,
  },
}

ll.setup {
  -- tabline = {
  --   lualine_b = {
  --     {
  --       'tabs',
  --       mode = 2,
  --       tabs_color = {
  --         active = 'DefinitionSearch',
  --         inactive = 'NonText'
  --       },
  --     }
  --   },
  --   lualine_y = {
  --     'buffers'
  --   },
  -- },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      {
        'filename',
        newfile_status = true,
      },
      -- { 'branch' },
      { 'diff' },
      { 'diagnostics' },
    },
    lualine_c = {},
    lualine_x = {
      -- https://github.com/SmiteshP/nvim-navic#lualine
      {
        "require'lsp-status'.status()",
        separator = '', -- Component separator
        padding = { left = 0, right = 0 },
      },
      -- https://github.com/rmagatti/auto-session#statusline
      {
        function() -- show session name
          return vim.fn.fnamemodify(vim.v.this_session, ':t')
        end,
        icon = { '', align = 'left' },
        separator = { left = "", right = "" },
        padding = { left = 0, right = 1 },
      },
    },
    lualine_y = {
      -- :h 'statusline' to check vim statusline symbols
      -- another example: "Ln %l/%L, Col %c"
      function() return [[%l:%c %L]] end,
    },
    lualine_z = {
      function() return " " .. vim.o.shiftwidth end,
      'encoding',
      { 'filetype', colored = false },
    }
  },
  inactive_sections = {},
  -- keep: quickfix, fugitive
  extensions = { "nvim-tree", "toggleterm", "symbols-outline", "nvim-dap-ui", "fzf" }
}

local navic = require("nvim-navic")
navic.setup({
  depth_limit = 4
})
local winbar = function()
  return {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        "filename",
        path = 1,
        newfile_status = true,
        shorting_target = 20,
        fmt = function(str) return str:gsub("^/", ""):gsub("/", " > ") end,
        separator = ">",
        icon = { '  ', align = 'left' },
        padding = { left = 0, right = 1 },
      },
      {
        navic.get_location, -- SmiteshP/nvim-navic
        cond = navic.is_available,
      },
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  }
end
ll.setup({
  winbar = winbar(),
  inactive_winbar = winbar(),
})

ll.setup {
  options = {
    theme = 'auto',
  }
}
-- Set same background color with editor zone
vim.cmd [[au ColorScheme * hi! link lualine_c_inactive Normal]]
vim.cmd [[au ColorScheme * hi! link lualine_c_normal Normal]]
vim.cmd [[au ColorScheme * hi! link lualine_c_insert Normal]]
vim.cmd [[au ColorScheme * hi! link lualine_c_visual Normal]]
vim.cmd [[au ColorScheme * hi! link lualine_c_replace Normal]]
vim.cmd [[au ColorScheme * hi! link lualine_c_command Normal]]
