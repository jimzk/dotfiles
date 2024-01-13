local M = {
  "nvim-lualine/lualine.nvim",
  event = "VimEnter",
  dependencies = {
    { "akinsho/bufferline.nvim", enabled = false },
    { "romgrk/barbar.nvim", enabled = false },
  },
}

local lazy_util = require("lazyvim.util")
local load_component = function(name, opts)
  return vim.tbl_extend("force", require("plugins.ui.lualine.components")[name], opts or {})
end

M.opts = function()
  local lualine_require = require("lualine_require")
  lualine_require.require = require
  local icons = require("lazyvim.config").icons
  vim.o.laststatus = vim.g.lualine_laststatus
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
    lualine_a = {
      vim.tbl_extend(
        "force",
        lazy_util.lualine.root_dir({
          cwd = true,
          icon = "󱉭",
        }),
        {
          separator = "",
          padding = { left = 1, right = 1 },
          color = {
            fg = "#292c3d",
            bg = "#8caaef",
          },
        }
      ),
    },

    lualine_b = {
      {
        "branch",
        icon = "",
        color = {
          fg = "#c6d0f6",
          bg = "#6e69a7",
        },
      },
      load_component("grapple", {}),
      -- { lazy_util.lualine.pretty_path() },
    },
    lualine_c = {},
    lualine_y = {},
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
          padding = { left = 0, right = 1 },
          color = color,
        },
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
        },
      },
    }
    return winbnar
  end

  opts.winbar = get_winbar({ bg = "#6369a7", fg = "#c6d0f6" })
  opts.inactive_winbar = get_winbar({ bg = "#44406e", fg = "#c6d0f6" })

  opts.sections = {
    lualine_a = {
      {
        "mode",
      },
    },
    lualine_b = {
      {
        "tabs",
        show_modified_status = false,
        tabs_color = {
          active = {
            fg = "#292c3d",
            bg = "#8e8ebd",
          },
          inactive = {
            bg = "#292c3d",
            fg = "#8e8ebd",
          },
        },
      },
      -- { require("lazyvim.util").lualine.pretty_path() },
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
        color = lazy_util.ui.fg("Debug"),
      },
      {
        require("lazy.status").updates,
        cond = require("lazy.status").has_updates,
        color = lazy_util.ui.fg("Special"),
      },
      load_component("progress"), -- Customized progress to avoid spacing change
    },
    lualine_y = {
      -- require("plugins.ui.lualine.visual-line"),
      -- require("plugins.ui.lualine.indent-with"),
      load_component("copilot", {
        -- separator = "",
        padding = { left = 1, right = 0 },
        color = {
          gui = "bold",
          fg = "#8caaef",
        },
      }),
      load_component("conform", {
        -- separator = "",
        padding = { left = 1, right = 0 },
        color = {
          fg = "#8caaef",
        },
      }),
      load_component("lsp_clients", {
        separator = "",
        padding = { left = 1, right = 1 },
        color = {
          fg = "#8caaef",
        },
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

  vim.cmd([[
  hi lualine_b_inactive guibg=#303447
  hi lualine_b_normal guibg=#303447
  hi lualine_b_command guibg=#303447
  hi lualine_b_visual guibg=#303447
  hi lualine_b_terminal guibg=#303447
  hi lualine_b_replace guibg=#303447
  hi lualine_b_insert guibg=#303447

  hi lualine_a_inactive guibg=#303447
  ]])
end

return M
