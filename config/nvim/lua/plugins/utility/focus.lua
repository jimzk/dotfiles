local M = {
  -- Auto resize focused window
  "nvim-focus/focus.nvim",
  enabled = true,
  event = "VeryLazy",
  keys = {
    {
      "<leader>o\\",
      function()
        require("util").toggle(not vim.g.focus_disable, function()
          vim.cmd("FocusToggle")
        end, "Windows Autoresize (Focus)", "Option")
      end,
      desc = "Toggle Windows Autoresize (Focus)",
    },
    {
      "<leader>o=",
      function()
        vim.cmd("FocusEnable")
        -- ISSUE:in autoresize mode the first will equalize
        vim.cmd("FocusMaxOrEqual")
        -- if is_win_maximize() then
        --   vim.cmd("FocusEqualise")
        -- else
        --   vim.cmd("FocusMaximise")
        -- end
      end,
      desc = "Toggle Full Window (Focus)",
    },
  },
}

M.init = function()
  -- Disable autoresize for certain filetypes/buftypes
  -- https://github.com/nvim-focus/focus.nvim#disabling-focus
  local ignore_filetypes = { "neo-tree" }
  local ignore_buftypes = { "nofile", "prompt", "popup" }

  local augroup = vim.api.nvim_create_augroup("FocusDisable", { clear = true })
  vim.api.nvim_create_autocmd("WinEnter", {
    group = augroup,
    callback = function(_)
      if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
        vim.w.focus_disable = true
      else
        vim.w.focus_disable = false
      end
    end,
    desc = "Disable focus autoresize for BufType",
  })
  vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    callback = function(_)
      if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
        vim.b.focus_disable = true
      else
        vim.b.focus_disable = false
      end
    end,
    desc = "Disable focus autoresize for FileType",
  })
end

M.opts = {
  autoresize = {
    -- enable = false,
    -- fix posession error: 'winwidth' cannot be smaller than 'winminwidth': winwidth=1
    minwidth = 1, -- Force minimum width for the unfocused window
  },
  ui = {
    signcolumn = false, -- Display signcolumn in the focussed window only
    cursorline = true,
  },
}

M.config = function(_, opts)
  local focus = require("focus")
  focus.setup(opts)
  -- This plugin can only disable autoresize entirely
  vim.cmd("FocusDisable")
end

return M
