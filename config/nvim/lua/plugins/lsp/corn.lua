local M = {
  -- Show Diagnostic in right hand side
  "RaafatTurki/corn.nvim",
  enabled = true,
  event = "BufReadPost",
}

local diagnostics_icons = {
  [vim.diagnostic.severity.ERROR] = require("lazyvim.config").icons.diagnostics.Error,
  [vim.diagnostic.severity.WARN] = require("lazyvim.config").icons.diagnostics.Warn,
  [vim.diagnostic.severity.HINT] = require("lazyvim.config").icons.diagnostics.Hint,
  [vim.diagnostic.severity.INFO] = require("lazyvim.config").icons.diagnostics.Info,
}

local enabled_diagnostics_opts = {
  virtual_text = {
    spacing = 1,
    source = "if_many",
    prefix = function(diagnostic)
      return diagnostics_icons[diagnostic.severity] or "?"
    end,
    -- format = function(diagnostic)
    --   return ""
    -- end,
  },
}

local disabled_diagnostics_opts = {
  underline = false,
  virtual_text = false,
}

M.dependencies = {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = disabled_diagnostics_opts,
    },
  },
}

M.opts = {
  on_toggle = function(is_hidden)
    -- Turn on builtin inline diagnostics when corn is hidden, and vice versa
    local opts = is_hidden and disabled_diagnostics_opts or enabled_diagnostics_opts
    vim.diagnostic.config(opts)
  end,
  icons = {
    error = require("lazyvim.config").icons.diagnostics.Error,
    warn = require("lazyvim.config").icons.diagnostics.Warn,
    hint = require("lazyvim.config").icons.diagnostics.Hint,
    info = require("lazyvim.config").icons.diagnostics.Info,
  },
  -- Disable truncation
  item_preprocess_func = function(item)
    return item
  end,
}

M.config = function(_, opts)
  require("corn").setup(opts)
  vim.cmd([[
    hi! DiagnosticVirtualTextError guibg=none
    hi! DiagnosticVirtualTextWarn guibg=none
    hi! DiagnosticVirtualTextHint guibg=none
    hi! DiagnosticVirtualTextInfo guibg=none
  ]])
end

return M
