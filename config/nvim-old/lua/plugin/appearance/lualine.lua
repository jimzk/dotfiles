local ll = require("lualine")
ll.setup {
  options = {
    theme = 'auto',
    icons_enabled = true,
    section_separators = '',
    component_separators = '',
    -- component_separators = { left = '|', right = '|' },
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
    lualine_b = {
      {
        function() return string.rep(" ", view.View.width) end,
        cond = view.is_visible,
        color = "Normal",
        padding = { left = 0, right = 1 },
      },
      {
        'tabs',
        max_length = vim.o.columns,
        mode = 2,
        tabs_color = {
          -- active = 'DefinitionSearch',
          -- inactive = 'NonText'
        },
        fmt = function(name, context)
          -- Show + if buffer is modified in tab
          local buflist = vim.fn.tabpagebuflist(context.tabnr)
          local winnr = vim.fn.tabpagewinnr(context.tabnr)
          local bufnr = buflist[winnr]
          local mod = vim.fn.getbufvar(bufnr, '&mod')
          if mod then
            name = name .. (mod == 1 and ' [+] ' or '')
          end
          local readonly = vim.fn.getbufvar(bufnr, "&readonly")
          if readonly then
            name = name .. (readonly == 1 and ' [-]' or '')
          end
          return name
        end
      }
    },
    lualine_x = {
      -- https://github.com/rmagatti/auto-session#statusline
      { -- show session name
        function()
          return vim.fn.fnamemodify(vim.v.this_session, ':t')
        end,
        icon = { '', align = 'left' },
        cond = function() return vim.v.this_session ~= '' end,
        padding = { left = 0, right = 1 },
        separator = "|",
      },
    },
  },

  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      -- { -- Show pwd
      --   -- TODO: show from git repo
      --   function()
      --     return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
      --   end,
      --   icon = { '', align = 'left' },
      --   padding = { left = 1, right = 0 },
      -- },
      -- {
      --   'filename',
      --   newfile_status = true,
      --   path = 3,
      --   shorting_target = 100,
      -- },
      {
        "branch",
        padding = { left = 1, right = 1 },
      },
      {
        'diff',
        padding = { left = 0, right = 1 },
      },
      { 'diagnostics' },
    },
    lualine_c = {},
    lualine_x = {
      -- { -- Show pwd
      --   function() return vim.fn.fnamemodify(vim.fn.getcwd(), ":t") end,
      --   icon = { '', align = 'left' },
      --   padding = { left = 1, right = 0 },
      -- },
      { -- List active lsp
        function()
          local clients = {}
          for _, client in ipairs(vim.lsp.get_active_clients()) do
            table.insert(clients, client.name)
          end
          return table.concat(clients, " ")
        end,
        icon = { '', align = 'left' },
        padding = { left = 1, right = 1 },
      },
    },
    lualine_y = {
      -- :h 'statusline' to check vim statusline symbols
      -- another example: "Ln %l/%L, Col %c"
      function() return [[%l:%c %L]] end,
    },
    lualine_z = {
      {
        function() return vim.o.shiftwidth end,
        icon = { '', align = 'left' },
        separator = "|",
      },
      {
        'encoding',
        separator = "|",
      },
      {
        'filetype',
        colored = false,
        separator = "|",
      },
    }
  },
  inactive_sections = {},
  -- keep: quickfix, fugitive
  extensions = { "nvim-tree", "toggleterm", "symbols-outline", "nvim-dap-ui", "fzf" }
}

-- local navic = require("nvim-navic")
-- navic.setup({
--   depth_limit = 4
-- })

-- local winbar = {
--   lualine_a = {},
--   lualine_b = {
--     {
--       "filename",
--       path = 1,
--       newfile_status = true,
--       shorting_target = 35,
--       -- fmt = function(str) return str:gsub("^/", ""):gsub("/", "/") end,
--       separator = ">>",
--       icon = { ' ', align = 'left' },
--       padding = { left = 0, right = 1 },
--       color = "lualine_b_normal",
--     },
--   },
--   lualine_c = {
--     {
--       function() return " " end,
--       padding = { left = 0, right = 0 },
--       separator = ">",
--     },
--     {
--       navic.get_location, -- SmiteshP/nvim-navic
--       cond = navic.is_available,
--       padding = { left = 1, right = 0 },
--     },
--   },
--   lualine_x = {},
--   lualine_y = {},
--   lualine_z = {},
-- }
-- ll.setup({
--   -- winbar = winbar,
--   -- inactive_winbar = winbar,
-- })

-- Set same background color with editor zone
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.cmd [[
hi! link lualine_c_inactive Normal
hi! link lualine_c_normal Normal
" No work. I don't know why
" hi! lualine_transitional_lualine_b_normal_to_lualine_c_normal guibg=#2e3440
]]
  end
})
