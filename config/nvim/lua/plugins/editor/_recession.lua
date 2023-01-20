return {
  "stevearc/resession.nvim",
  event = "VeryLazy",
  opts = {
    dir = "resession",
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
      -- "number",
      -- "relativenumber",
    },
    extensions = {
      quickfix = {},
      aerial = {},
    },
  },
  config = function(_, opts)
    local resession = require("resession")
    resession.setup(opts)
    -- https://github.com/nvim-neo-tree/neo-tree.nvim/issues/128
    -- resession.add_hook("post_load", function()
    --   require("neo-tree.sources.manager").show("filesystem")
    -- end)
    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        if resession.get_current() then
          resession.save_all({ notify = false })
        end
      end,
    })
  end,
}
