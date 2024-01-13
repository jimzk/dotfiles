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
  return {
    options = {
      theme = "auto",
      globalstatus = true,
      disabled_filetypes = {
        statusline = { "dashboard", "alpha", "starter" },
        winbar = { "neo-tree" },
      },
      section_separators = "",
      component_separators = "",
    },
    tabline = {
      lualine_b = {
        vim.tbl_extend(
          "force",
          lazy_util.lualine.root_dir({
            cwd = true,
            icon = "󱉭",
          }),
          {
            separator = "",
            padding = { left = 1, right = 1 },
          }
        ),
        -- { Util.lualine.pretty_path() },
        -- vim.tbl_extend(
        --   "force",
        --   lazy_util.lualine.root_dir({
        --     cwd = true,
        --     icon = "󱉭",
        --   }),
        --   {
        --     color = lazy_util.ui.fg("@text.todo"),
        --     separator = "",
        --     padding = { left = 1, right = 1 },
        --   }
        -- ),
        load_component("harpoon2", {}),
      },
      --   --   lualine_b = {},
      --   --   lualine_c = {},
      --   --   lualine_x = {},
      lualine_z = {
        "tabs",
      },
    },
    winbar = {
      lualine_b = {
        {
          "filename",
          newfile_status = true,
          path = 1,
          padding = { left = 1, right = 1 },
          cond = function()
            return vim.bo.buflisted
          end,
        },
      },
    },
    inactive_winbar = {
      lualine_b = {
        {
          "filename",
          newfile_status = true,
          path = 1,
          padding = { left = 1, right = 1 },
          cond = function()
            return vim.bo.buflisted
          end,
        },
      },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = {
        {
          "branch",
          icon = "",
        },
        -- { require("lazyvim.util").lualine.pretty_path() },
      },
      lualine_c = {
        -- {
        --   "aerial",
        --   sep = " ", -- separator between symbols
        --   sep_icon = "", -- separator between icon and symbol
        --   depth = -1,
        -- },
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
          padding = { left = 1, right = 0 },
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
          padding = { left = 1, right = 0 },
        },
        load_component("progress", {
          color = { fg = "#8caaef" },
        }), -- Customized progress to avoid spacing change
      },
      lualine_y = {
        -- require("plugins.ui.lualine.visual-line"),
        -- require("plugins.ui.lualine.indent-with"),
        load_component("copilot", {
          -- separator = "",
          padding = { left = 1, right = 0 },
        }),
        load_component("conform", {
          -- separator = "",
          padding = { left = 1, right = 0 },
        }),
        load_component("lsp_clients", {
          separator = "",
          padding = { left = 1, right = 0 },
        }),
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 1 } },
      },
      lualine_z = {
        function()
          return " " .. os.date("%R")
        end,
      },
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
end

M.config = function(_, opts)
  require("lualine").setup(opts)

  vim.cmd([[hi lualine_b_inactive guibg=#303447]])
  vim.cmd([[hi lualine_b_normal guibg=#303447]])
  vim.cmd([[hi lualine_b_command guibg=#303447]])
  vim.cmd([[hi lualine_b_visual guibg=#303447]])
  vim.cmd([[hi lualine_b_terminal guibg=#303447]])
  vim.cmd([[hi lualine_b_replace guibg=#303447]])
  vim.cmd([[hi lualine_b_insert guibg=#303447]])
end

return M
