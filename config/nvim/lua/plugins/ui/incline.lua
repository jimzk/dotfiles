local M = {
  -- Float windows to show file info
  "b0o/incline.nvim",
  event = "VeryLazy",
  enabled = false,
}

M.keys = {
  {
    "<leader>oe",
    function()
      local incline = require("incline")
      Util.toggle(incline.is_enabled, incline.toggle, "Incline")
    end,
    desc = "Toggle Incline",
  },
}

M.opts = {
  window = {
    padding = 0,
    margin = { horizontal = 0 },
    placement = {
      horizontal = "right",
      vertical = "bottom", -- bottom
    },
  },
  highlight = {
    groups = {
      InclineNormal = {
        guibg = "#6e69a7", -- #44406e
        default = true,
        -- group = "@text.danger",
      },
      InclineNormalNC = {
        guibg = "#44406e", -- #44406, #2d2a49
        -- guifg = "#838ba8",
        default = true,
      },
    },
  },
  ignore = {
    buftypes = {},
    filetypes = { "neo-tree", "edgy", "lazyterm", "aerial" },
    unlisted_buffers = false,
  },
  render = function(props)
    local format_labels = function(labels)
      if #labels > 0 then
        for i = 1, #labels - 1 do
          labels[i][1] = labels[i][1] .. " "
        end
        table.insert(labels, 1, { " " })
      end
    end

    local function get_filename()
      local labels = {}
      local full_filename = vim.api.nvim_buf_get_name(props.buf)
      -- local filename = vim.fn.fnamemodify(full_filename, ":t") -- basename
      local filename = vim.fn.fnamemodify(full_filename, ":.") -- relative name
      -- filename = full_filename:gsub("^" .. vim.env.HOME, "~") -- cut off HOME prefix
      if filename == "" then
        filename = "[No Name]"
      end
      local devicons = require("nvim-web-devicons")
      local ft_icon, ft_color = devicons.get_icon_color(filename)
      if ft_icon ~= nil then
        table.insert(labels, { ft_icon, guifg = ft_color, guibg = "none" })
      end
      table.insert(labels, { filename })
      -- if vim.bo[props.buf].modified then
      --   table.insert(labels, { "[+]" })
      -- end
      if not vim.bo[props.buf].modifiable then
        table.insert(labels, { "" })
      end
      format_labels(labels)
      return labels
    end

    local function get_git_diff()
      local icons = { added = "", changed = "", removed = "" }
      local signs = vim.b[props.buf].gitsigns_status_dict
      local labels = {}
      if signs == nil then
        return labels
      end
      for name, icon in pairs(icons) do
        if tonumber(signs[name]) and signs[name] > 0 then
          table.insert(labels, { icon .. " " .. signs[name], group = "Diff" .. name })
        end
      end
      format_labels(labels)
      return labels
    end

    local function get_diagnostic_label()
      local icons = { error = "", warn = "", hint = "", info = "" }
      local labels = {}
      for severity, icon in pairs(icons) do
        local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
        if n > 0 then
          table.insert(labels, { icon .. " " .. n, group = "DiagnosticSign" .. severity })
        end
      end
      format_labels(labels)
      return labels
    end

    local function get_progress()
      local helpers = require("incline.helpers")
      local labels = {}
      local text = helpers.eval_statusline("%l:%02c %LL", { winid = props.win })[1][1]
      table.insert(labels, { text, guifg = "#eeeeee" })
      format_labels(labels)
      return labels
    end

    return {
      { get_diagnostic_label() },
      { get_git_diff() },
      { get_progress() },
      { get_filename() },
      { " " },
    }
  end,
}

return M
