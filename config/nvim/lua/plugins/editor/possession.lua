return {
  "jedrzejboczar/possession.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "VeryLazy",
  opts = {
    -- Disable notification
    silent = true,
    load_silent = true,
    autosave = {
      current = true,
    },
    hooks = {
      before_save = function(_)
        vim.cmd [[wincmd =]] -- Turn off full windows
        return {}
      end,
    },
    plugins = {
      delete_hidden_buffers = {
        hooks = {}, -- Do not delete buffers at saving
      },
      close_windows = {
        hooks = { "before_save" },
        preserve_layout = false, -- do not preserse empty window
        match = {
          -- buftype = { "help" },
          filetype = { "neo-tree", "aerial", "NeogitStatus", "NeogitCommitView", "toggleterm", "fugitiveblame" }
        },
      },
    },
  },
  config = function(_, opts)
    require("possession").setup(opts)
    require("telescope").load_extension("possession")
  end,
}
