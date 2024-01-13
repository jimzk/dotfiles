local M = {
  "jedrzejboczar/possession.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "folk/persistence.nvim", enabled = false },
  },
  event = "VimEnter",
}

M.init = function()
  -- Persistent pinned tabs. See https://github.com/romgrk/barbar.nvim/issues/361#issuecomment-1442004214
  vim.opt.sessionoptions:append("globals")
end

M.keys = {
  {
    "<leader>ps",
    function()
      local sessions = { "[Create New]" }
      local path = vim.fn.stdpath("data") .. "/possession"
      for _, file in ipairs(vim.split(vim.fn.glob(path .. "/*.json"), "\n")) do
        table.insert(sessions, vim.fn.fnamemodify(file, ":t:r"))
      end
      vim.ui.select(sessions, {
        prompt = "Overwrite Session",
      }, function(choice)
        if not choice then
          vim.notify("No session overwritten or saved", vim.log.levels.WARN, { title = "Posession" })
          return
        end
        if choice == "[Create New]" then
          vim.ui.input({
            prompt = "New Session Name",
          }, function(name)
            if not name then
              return
            end
            vim.cmd("PossessionSave! " .. name)
          end)
        else
          vim.cmd("PossessionSave! " .. choice)
        end
      end)
    end,
    desc = "Create/Overwrite Session",
  },
  -- { "<leader>pd", "<CMD>PossessionDelete<CR>", desc = "Delete Current Session" },
  { "<leader>pq", "<CMD>PossessionClose<CR>", desc = "Close Current Session" },
  {
    "<leader>pl",
    function()
      require("telescope").extensions.possession.list(require("telescope.themes").get_dropdown({
        layout_config = { mirror = true },
      }))
    end,
    desc = "List Session",
  },
  {
    "<leader>pp",
    function()
      -- https://github.com/nvim-telescope/telescope-project.nvim
      require("telescope").extensions.project.project({
        prompt_title = "Find Git Projects",
        display_type = "minimal", -- or full
      })
    end,
    desc = "List Git Project in Workspace",
  },
}

M.opts = {
  -- Set silent to `true` to disable notification
  silent = true,
  load_silent = true,
  autosave = {
    current = true,
  },
  hooks = {
    --   before_save = function(_)
    --     vim.cmd([[wincmd =]]) -- Turn off full windows
    --     return {}
    --   end,
    after_load = function(name, user_data)
      local manager = require("neo-tree.sources.manager")
      local renderer = require("neo-tree.ui.renderer")
      local state = manager.get_state("filesystem")
      local neo_tree_exists = renderer.window_exists(state)
      if neo_tree_exists then
        local timer = require("luv").new_timer()
        timer:start(
          100,
          0,
          vim.schedule_wrap(function()
            vim.cmd("Neotree reveal action=show")
          end)
        )
      end
    end,
  },
  --
  plugins = {
    delete_hidden_buffers = {
      hooks = {}, -- Do not delete buffers at saving
    },
    close_windows = {
      hooks = { "before_save" },
      preserve_layout = false, -- do not preserse empty window
      match = {
        filetype = {
          -- "neo-tree",
          -- "aerial",
          -- "edgy",
          "NeogitStatus",
          "NeogitCommitView",
          "Trouble",
          -- "markdown",
        },
      },
    },
  },
  telescope = {
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
}

M.config = function(_, opts)
  require("possession").setup(opts)
  require("telescope").load_extension("possession")
end

return M
