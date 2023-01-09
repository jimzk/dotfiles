local ll = require("lualine")
ll.setup {
  options = {
    theme = 'auto',
    icons_enabled = true,
    section_separators = '',
    component_separators = { left = '|', right = '|' },
    -- section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = { "TelescopePrompt" },
      -- winbar = { "NvimTree", "gitcommit", "fugitive", "fugitiveblame", "untotree", "toggleterm", "" },
      winbar = Utils.non_code_filetypes,
    },
    ignore_focus = { "NvimTree", "lspsagaoutline" },
    always_divide_middle = true,
    refresh = {
      statusline = 800,
      tabline = 1000,
      winbar = 1000,
    },
    globalstatus = true,
  },
}

local view = require("nvim-tree.view")
ll.setup {
  tabline = {
    lualine_a = {
      {
        function()
          return string.rep(" ", view.View.width)
        end,
        cond = view.is_visible,
        color = "Normal",
        padding = { left = 0, right = 1 },
      },
      {
        'tabs',
        mode = 2,
        tabs_color = {
          -- active = 'DefinitionSearch',
          inactive = 'NonText'
        },
      }
    },
    lualine_x = {
      {
        'branch',
        padding = { left = 0, right = 2 },
      }
    },
  },

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

local winbar = {
  lualine_a = {},
  lualine_b = {
    {
      "filename",
      path = 1,
      newfile_status = true,
      shorting_target = 35,
      -- fmt = function(str) return str:gsub("^/", ""):gsub("/", "/") end,
      separator = ">>",
      icon = { ' ', align = 'left' },
      padding = { left = 0, right = 1 },
      color = "lualine_b_normal",
    },
  },
  lualine_c = {
    {
      function() return " " end,
      padding = { left = 0, right = 0 },
      separator = ">",
    },
    {
      navic.get_location, -- SmiteshP/nvim-navic
      cond = navic.is_available,
      padding = { left = 1, right = 0 },
    },
  },
  lualine_x = {},
  lualine_y = {},
  lualine_z = {},
}
ll.setup({
  winbar = winbar,
  inactive_winbar = winbar,
})

-- Set same background color with editor zone
vim.cmd [[au ColorScheme * hi! link lualine_c_inactive Normal]]
vim.cmd [[au ColorScheme * hi! link lualine_c_normal Normal]]
