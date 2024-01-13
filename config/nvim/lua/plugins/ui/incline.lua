local M = {
  -- Float windows to show file info
  "b0o/incline.nvim",
  event = "VeryLazy",
  enabled = false,
}

M.opts = function()
  local devicons = require("nvim-web-devicons")
  local opts = {
    window = {
      padding = 0,
      margin = { horizontal = 0 },
      placement = {
        horizontal = "left",
        vertical = "bottom",
      },
    },
    highlight = {
      groups = {
        InclineNormal = {
          -- guibg = "#44406e",
          guibg = "#6e69a7",
          default = true,
          -- group = "@text.danger",
        },
        InclineNormalNC = {
          guibg = "#44406e",
          -- guibg = "#2d2a49",
          guifg = "#838ba8",
          default = true,
        },
      },
    },
  }

  opts.render = function(props)
    -- local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")  -- filename
    local filename = vim.fn.fnamemodify(vim.fn.bufname(props.buf), ":~:.") -- filename + relative path
    filename = filename:gsub("^" .. vim.env.HOME, "~") -- cut off HOME prefix
    if filename == "" then
      filename = "[No Name]"
    end
    local ft_icon, ft_color = devicons.get_icon_color(filename)

    local function get_git_diff()
      local icons = { added = "", changed = "", removed = "" }
      local signs = vim.b[props.buf].gitsigns_status_dict
      local labels = {}
      if signs == nil then
        return labels
      end
      for name, icon in pairs(icons) do
        if tonumber(signs[name]) and signs[name] > 0 then
          if #labels == 0 then
            table.insert(labels, { " " })
          end
          table.insert(labels, { icon .. " " .. signs[name] .. " ", group = "Diff" .. name })
        end
      end
      -- if #labels > 0 then
      --   table.insert(labels, { "┊" })
      -- end
      return labels
    end

    local function get_diagnostic_label()
      local icons = { error = "", warn = "", hint = "", info = "" }
      local labels = {}
      for severity, icon in pairs(icons) do
        local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
        if n > 0 then
          if #labels == 0 then
            table.insert(labels, { " " })
          end
          table.insert(labels, { icon .. " " .. n .. " ", group = "DiagnosticSign" .. severity })
        end
      end
      -- if #labels > 0 then
      --   table.insert(labels, { "┊" })
      -- end
      return labels
    end

    return {
      { " " .. (ft_icon or "") .. " ", guifg = ft_color, guibg = "none" },
      { filename .. " ", gui = vim.bo[props.buf].modified and "bold,italic" or "bold" },
      { get_diagnostic_label() },
      { get_git_diff() },
    }
  end

  return opts
end

return M
