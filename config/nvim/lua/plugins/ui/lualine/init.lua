local M = {
  "nvim-lualine/lualine.nvim",
  event = "VimEnter",
  dependencies = {
    { "akinsho/bufferline.nvim", enabled = false },
    { "romgrk/barbar.nvim", enabled = false },
  },
}

M.opts = function()
  local lualine_require = require("lualine_require")
  lualine_require.require = require
  local icons = require("lazyvim.config").icons
  vim.o.laststatus = vim.g.lualine_laststatus

  local components = require("plugins.ui.lualine.components")
  local opts = {
    options = {
      theme = "auto",
      globalstatus = true,
      disabled_filetypes = {
        statusline = { "dashboard", "alpha", "starter" },
        winbar = { "neo-tree", "aerial", "dashboard" },
      },
      section_separators = "",
      component_separators = "",
    },
    extensions = {
      "aerial",
      "lazy",
      "neo-tree",
      "nvim-dap-ui",
      "quickfix",
      "trouble",
    },
  }
  opts.tabline = {
    lualine_a = {},
    lualine_x = {
      {
        "branch",
        icon = "",
        color = {
          fg = "#c6d0f6",
          bg = "#6e69a7",
        },
      },
      vim.tbl_extend(
        "force",
        LazyVim.lualine.root_dir({
          cwd = true,
          icon = "󱉭",
        }),
        {
          separator = "",
          padding = { left = 1, right = 1 },
          color = {
            bg = "#8caaef",
            fg = "#292c3d",
          },
        }
      ),
    },

    lualine_b = {
      {
        "tabs",
        padding = { left = 1, right = 1 },
        max_length = vim.o.columns,
        mode = 0,
        path = 1,
        show_modified_status = false,
      },
      components.arrow({
        padding = { left = 0, right = 0 },
      }),
      -- { LazyVim.lualine.pretty_path() },
    },
    -- lualine_c = {},
    -- lualine_y = {},
  }

  local get_winbar = function(color)
    local winbnar = {
      lualine_a = {
        {
          "filetype",
          icon_only = true,
          separator = "",
          padding = { left = 1, right = 0 },
          color = color,
        },
        {
          "filename",
          newfile_status = true,
          path = 1,
          padding = { left = 0, right = 0 },
          color = color,
        },
        components.progress({
          separator = "",
          icon = "󰛗",
          color = {
            bg = color.bg,
            fg = "#9db7f1",
          },
          padding = { left = 1, right = 1 },
        }),
        {
          "diff",
          symbols = {
            added = icons.git.added,
            modified = icons.git.modified,
            removed = icons.git.removed,
          },
          source = function()
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
              return {
                added = gitsigns.added,
                modified = gitsigns.changed,
                removed = gitsigns.removed,
              }
            end
          end,
          separator = "",
          padding = { left = 0, right = 1 },
          color = color,
        },
        {
          "diagnostics",
          symbols = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warn,
            info = icons.diagnostics.Info,
            hint = icons.diagnostics.Hint,
          },
          separator = "",
          padding = { left = 0, right = 1 },
          color = color,
        },
      },
      lualine_b = {
        {
          function()
            return " "
          end,
          color = {
            bg = "Normal",
          },
        },
      },
    }
    return winbnar
  end

  opts.winbar = get_winbar({ bg = "#6369a7", fg = "#c6d0f6" })
  opts.inactive_winbar = get_winbar({ bg = "Normal", fg = "#c6d0f6" })

  opts.sections = {
    lualine_a = {
      {
        "mode",
        fmt = function(str)
          return str:sub(1, 6)
        end,
      },
    },
    lualine_b = {
      -- {
      --   function()
      --     -- return vim.g.cut_clipboard_enabled and "󰅇" or ""
      --     return vim.g.cut_clipboard_enabled and "✅" or "❌"
      --   end,
      --   padding = { left = 1, right = 1 },
      -- },

      -- {
      --   "tabs",
      --   show_modified_status = false,
      --   tabs_color = {
      --     active = {
      --       fg = "#292c3d",
      --       bg = "#8e8ebd",
      --     },
      --     inactive = {
      --       bg = "#292c3d",
      --       fg = "#8e8ebd",
      --     },
      --   },
      -- },
      -- { LazyVim.lualine.pretty_path() },
    },
    lualine_c = {
      {
        "aerial",
        sep_icon = "",
        sep = " ► ",
        -- depth = -1,
      },
    },
    lualine_x = {
      -- stylua: ignore
      {
        function() return "  " .. require("dap").status() end,
        cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
        color = LazyVim.ui.fg("Debug"),
      },
      {
        require("lazy.status").updates,
        cond = require("lazy.status").has_updates,
        color = LazyVim.ui.fg("Special"),
      },
    },
    lualine_y = {
      -- require("plugins.ui.lualine.visual-line"),
      components.copilot({
        -- separator = "",
        padding = { left = 1, right = 0 },
        color = {
          gui = "bold",
          fg = "#8caaef",
        },
      }),
      components.conform({
        -- separator = "",
        padding = { left = 1, right = 0 },
        color = {
          fg = "#8caaef",
        },
      }),
      components.lsp_clients({
        separator = "",
        padding = { left = 1, right = 0 },
        color = {
          fg = "#8caaef",
        },
      }),
      components.indent_width({
        padding = { left = 1, right = 1 },
      }),
    },
    lualine_z = {
      {
        function()
          return " " .. os.date("%R")
        end,
      },
    },
  }
  return opts
end

M.config = function(_, opts)
  require("lualine").setup(opts)

  -- local normal = vim.api.nvim_get_hl_by_name("normal", true)
  -- local postfixs = { "inactive", "normal", "command", "visual", "terminal", "replace", "insert" }
  -- for _, postfix in ipairs(postfixs) do
  --   local sections = { "b" }
  --   for _, section in ipairs(sections) do
  --     name = "lualine_" .. section .. "_" .. postfix
  --     local ok, hl = pcall(vim.api.nvim_get_hl_by_name, name, true)
  --     if ok and hl then
  --       local new_hl = {
  --         bg = normal.background,
  --         fg = hl.foreground,
  --       }
  --       vim.api.nvim_set_hl(0, name, new_hl)
  --     end
  --   end
  -- end
end

return M
