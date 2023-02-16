-- file explorer
return {
  "nvim-neo-tree/neo-tree.nvim",
  event = "VeryLazy", -- Loading on demand will cause first invoking slow
  dependencies = {
    "s1n7ax/nvim-window-picker",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    -- {
    --   "<leader>e",
    --   function() require("neo-tree.command").execute({ toggle = true, dir = Util.get_root() }) end,
    --   desc = "neo-tree (root dir)",
    -- },
    { "<leader>eE", "<cmd>Neotree action=show<cr>", desc = "file explorer (not jump)" },
    { "<leader>ee", "<cmd>Neotree action=focus<cr>", desc = "file explorer" },
    { "<leader>eq", "<cmd>Neotree close<cr>", desc = "close explorer" },
    -- { "<leader>eF", "<cmd>Neotree reveal action=show<cr>", desc = "focus on buffers (not jump)" },
    { "<leader>ef", "<cmd>Neotree reveal action=focus<cr>", desc = "focus on buffers" },
    { "<leader>eb", "<cmd>Neotree buffers<cr>", desc = "buffers explorer" },
    { "<leader>eg", "<cmd>Neotree git_status<cr>", desc = "git status exploer" },
  },
  init = function()
    vim.g.neo_tree_remove_legacy_commands = 1
    if vim.fn.argc() == 1 then
      local stat = vim.loop.fs_stat(vim.fn.argv(0))
      if stat and stat.type == "directory" then
        require("neo-tree")
      end
    end
  end,
  opts = {
    window = {
      -- :h neo-tree-mappings
      mappings = {
        S = "noop",
        v = { "open_vsplit" },
        s = { "open_split" },
        l = "noop",
        i = "focus_preview",
        o = "open_drop",
        w = "noop",
        ["<Cr>"] = "open_with_window_picker",
        R = "noop",
        ["<C-r>"] = "refresh",
        [">"] = "noop",
        ["<"] = "noop",
        ["]"] = "prev_source",
        ["["] = "next_source",
      },
    },
    filesystem = {
      -- follow_current_file = true,
      never_show = {
        ".DS_Store",
        "thumbs.db",
      },
      window = {
        width = 35,
        mappings = {
          ["<C-x>"] = "noop",
          F = { "clear_filter" },
          ["]g"] = "noop",
          ["[g"] = "noop",
          J = "next_git_modified",
          K = "prev_git_modified",
        },
      },
    },
  },
  config = function(_, opts)
    local cc = require("neo-tree.sources.common.commands")
    -- Open file in new tab with neotree shown
    cc.open_tabnew = (function(func)
          return function(...)
            func(...)
            vim.cmd [[Neotree reveal action=show]]
          end
        end)(cc.open_tabnew)
    require("neo-tree").setup(opts)
  end
}
