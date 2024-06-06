local key = "<Tab>"
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
        -- smart-open configuration
        -- https://github.com/barklan/smart-open.nvim/blob/main/lua/telescope/_extensions/smart_open/default_config.lua
        ignore_patterns = { "*.git/*", "*/tmp/*" },
        -- Telescope configuration
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
          map("i", key, function(prompt_bufnr)
            local position = vim.api.nvim_win_get_cursor(0)
            local is_at_line_start = position[2] == 4
            if is_at_line_start then
              actions.close(prompt_bufnr)
            else
              vim.api.nvim_buf_set_lines(prompt_bufnr, position[1] - 1, position[1], false, { "" })
            end
          end, { desc = "Close or Clean" })
          map("i", "<cr>", actions.overwrite_select_default, { desc = "overwrite_select_default" })
          map("i", "<C-cr>", actions.select_default + actions.center)

          -- actions.pin_buffer = function(prompt_bufnr)
          --   local state = require("telescope.actions.state")
          --   local entry = state.get_selected_entry()
          --   local path = vim.fn.fnamemodify(entry.path, ":~:.")
          --   require("arrow.persist").toggle(path)
          --   -- actions.close(prompt_bufnr)
          -- end
          -- map("i", "<M-p>", actions.pin_buffer, { desc = "Pin Buffer" })
          return true
        end,
      }))
    end
  end,
}
