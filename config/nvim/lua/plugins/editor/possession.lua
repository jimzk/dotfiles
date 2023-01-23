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
      before_save = function(name)
        vim.cmd [[wincmd =]] -- Turn off full windows
        return {}
      end,
    },
    plugins = {
      delete_hidden_buffers = {
        hooks = {
          "before_load",
          -- delete hidden buffer
          vim.o.sessionoptions:match("buffer") and "before_save",
        },
        -- Avoid autocmd error when save session with neogit
        force = true,
      },
      close_windows = {
        preserve_layout = true, -- preserse empty window
        match = {
          -- buftype = { "help" },
          filetype = { "neo-tree", "aerial", "NeogitStatus", "toggleterm" }
        },
      },
    },
  },
  config = function(_, opts)
    require("possession").setup(opts)
    require("telescope").load_extension("possession")
    _G.Util.posession_list = function()
      require("telescope").extensions.possession.list(require("telescope.themes").get_dropdown({
        layout_config = {
          mirror = true,
        },
      }))
    end
  end,
}
