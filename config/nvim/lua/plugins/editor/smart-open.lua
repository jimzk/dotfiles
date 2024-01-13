return {
  "danielfalk/smart-open.nvim",
  -- branch = "0.2.x",
  dependencies = {
    "kkharji/sqlite.lua",
    "nvim-telescope/telescope.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "nvim-telescope/telescope-frecency.nvim", enabled = true },
  },
  keys = {
    {
      "<C-g>",
      function()
        _G.smart_open()
      end,
      desc = "Smart Open File",
    },
    -- { "<leader><space>", "<leader>fs", remap = true, desc = "Smart Open Files" },
  },
  config = function()
    local telescope = require("telescope")
    local hbac = function()
      vim.cmd("Telescope hbac buffers")
    end
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
      require("telescope").extensions.smart_open.smart_open({
        prompt_title = "Smart Open",
        cwd_only = true,
        filename_first = true,
        hidden = true,
        no_ignore = true,
        default_text = line,
        -- attach_mappings = function(prompt_bufnr, map)
        --   vim.keymap.set("i", "<C-g>", function()
        --     require("telescope").extensions.hbac.buffers({
        --       default_text = action_state.get_current_line(),
        --     })
        --   end, { buffer = prompt_bufnr })
        --   return true
        -- end,
      })
    end
  end,
}
