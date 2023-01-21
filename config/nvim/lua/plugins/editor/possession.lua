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
    plugins = {
      -- Hack: avoid autocmd error when save session with neogit
      -- delete_hidden_buffers = false,
      delete_hidden_buffers = {
        hooks = {
          "before_load",
        },
        force = false,
      },
      close_windows = {
        match = {
          buftype = { "help" },
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
