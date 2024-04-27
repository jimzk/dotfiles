local key = "<C-g>"
return {
  "danielfalk/smart-open.nvim",
  -- branch = "0.2.x",
  dependencies = {
    "kkharji/sqlite.lua",
    "nvim-telescope/telescope.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  keys = {
    {
      key,
      function()
        _G.smart_open()
      end,
      desc = "Smart Open File",
    },
    -- { "<leader><space>", "<leader>fs", remap = true, desc = "Smart Open Files" },
  },
  config = function()
    local telescope = require("telescope")
    -- local actions = require("telescope.actions")
    -- local hbac = function()
    --   vim.cmd("Telescope hbac buffers")
    -- end
    telescope.setup({
      extensions = {
        smart_open = {
          match_algorithm = "fzf",
          -- mappings = {
          --   i = {
          --     ["<C-g>"] = hbac,
          --   },
          -- },
        },
      },
    })
    telescope.load_extension("smart_open")

    _G.smart_open = function()
      local action_state = require("telescope.actions.state")
      local line = action_state.get_current_line()
      local themes = require("telescope.themes")
      require("telescope").extensions.smart_open.smart_open(themes.get_dropdown({
        cwd_only = true,
        filename_first = true,
        -- Telescope config
        layout_config = {
          height = 30,
        },
        previewer = false,
        prompt_title = "Smart Open",
        hidden = true,
        no_ignore = true,
        default_text = line,
        attach_mappings = function(prompt_bufnr, map)
          -- vim.keymap.set("i", "<C-g>", function()
          --   require("telescope").extensions.hbac.buffers({
          --     default_text = action_state.get_current_line(),
          --   })
          -- end, { buffer = prompt_bufnr })
          local actions = require("telescope.actions")
          map("i", key, actions.close, { desc = "close" })
          actions.pin_buffer = function()
            local state = require("telescope.actions.state")
            local entry = state.get_selected_entry()
            local path = vim.fn.fnamemodify(entry.path, ":~:.")
            require("arrow.persist").toggle(path)
          end
          map("i", "<M-p>", actions.pin_buffer, { desc = "Pin Buffer" })
          return true
        end,
      }))
    end
  end,
}
