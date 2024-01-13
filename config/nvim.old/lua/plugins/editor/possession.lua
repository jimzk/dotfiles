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
          filetype = { "neo-tree", "aerial", "NeogitStatus", "NeogitCommitView", "toggleterm", "fugitiveblame", "oil" }
        },
      },
    },
    telescope = {
      previewer = nil, -- or false to disable previewer
      list = {
        default_action = "load",
        mappings = {
          load = { n = "<cr>", i = "<cr>" },
          save = { n = "<c-s>", i = "<c-s>" },
          delete = { n = "<c-d>", i = "<c-d>" },
          rename = { n = "<c-r>", i = "<c-r>" },
        },
      },
    },
  },
  config = function(_, opts)
    require("possession").setup(opts)
    require("telescope").load_extension("possession")
  end,
}
