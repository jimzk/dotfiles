local resession = require('resession')
resession.setup {
  dir = "session",
  autosave = {
    enabled = true,
    -- How often to save (in seconds)
    interval = 60,
    -- Notify when autosaved
    notify = false,
  },
  options = {
    "binary",
    "bufhidden",
    "buflisted",
    "cmdheight",
    "diff",
    "filetype",
    "modifiable",
    "previewwindow",
    "readonly",
    "scrollbind",
    "winfixheight",
    "winfixwidth",
    -- added options
    "tabstop",
    "shiftwidth",
  },
  extensions = {
    quickfix = {},
    aerial = {}
  },
}

-- https://github.com/stevearc/resession.nvim#create-one-session-per-directory
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc(-1) == 0 then
      resession.load()
    end
  end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    if resession.get_current() then
      resession.save_all({ notify = false })
    end
  end,
})
