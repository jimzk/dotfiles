return {
  -- Auto resize (enlarge) focused window
  "nvim-focus/focus.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<C-\\>",
      function()
        vim.cmd("FocusToggle")
        if vim.g.focus_disable then
          vim.notify("Focus mode off", vim.log.levels.INFO, { title = "focus.nvim" })
        else
          vim.notify("Focus mode on", vim.log.levels.INFO, { title = "focus.nvim" })
        end
      end,
      desc = "Toggle window autosize (focus)",
    },
    {
      "<C-0>",
      function()
        -- vim.cmd("FocusEnable")
        -- vim.cmd("FocusMaximise")
        vim.cmd("FocusMaxOrEqual")
      end,
      desc = "Toggle full window (focus)",
    },
  },
  opts = {
    -- autoresize == true messup harpoon and telescope.
    autoresize = {
      enable = true,
      -- width = 140,
      -- height = 40,
      -- Focus.lua will make sure window is not smaller than minwidth/minheight
      -- If there is no enough room then it will occupy toggleterm or quickfix size.
      -- Set minwidth/minheight to a small value.
      -- minwidth = 10,
      -- minheight = 5,
    },
    ui = {
      signcolumn = false, -- kepp signcolumn unchanged
    },
  },
  config = function(_, opts)
    require("focus").setup(opts)

    -- https://github.com/nvim-focus/focus.nvim#disabling-focus
    local ignore_filetypes = { "neo-tree", "qf" }
    local ignore_buftypes = { "nofile", "prompt", "popup", "help", "acwrite", "quifkfix", "terminal" }
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
  end,
}
