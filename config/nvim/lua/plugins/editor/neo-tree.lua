-- file explorer
return {
  "nvim-neo-tree/neo-tree.nvim",
  cmd = "Neotree",
  dependencies = {
    {
      "s1n7ax/nvim-window-picker",
      config = function()
        require("window-picker").setup({
          filter_rules = {
            bo = {
              buftype = { "terminal", "quickfix" },
            },
          },
          other_win_hl_color = "#e35e4f",
        })
      end,
    },
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
    { "<leader>eF", "<cmd>Neotree reveal action=show<cr>", desc = "focus on buffers (not jump)" },
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
    filesystem = {
      -- follow_current_file = true,
      never_show = {
        ".DS_Store",
        "thumbs.db",
      },
      window = {
        width = 35,
        mappings = {
          ["]"] = "next_git_modified",
          ["["] = "prev_git_modified",
          ["]g"] = "noop",
          ["[g"] = "noop",
        },
      },
    },
    window = {
      -- :h neo-tree-mappings
      mappings = {
        S = "noop",
        v = { "open_vsplit" },
        s = { "open_split" },
        -- P = "noop",
        -- o = "toggle_preview",
        o = "open_drop",
        ["<Cr>"] = "open_with_window_picker",
        w = "noop",
      },
    },
  },
}
