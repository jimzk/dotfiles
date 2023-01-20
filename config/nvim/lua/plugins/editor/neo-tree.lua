-- file explorer
return {
  "nvim-neo-tree/neo-tree.nvim",
  cmd = "Neotree",
  dependencies = { { "s1n7ax/nvim-window-picker", config = true } },
  keys = {
    {
      "<leader>e",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = Util.get_root() })
      end,
      desc = "neo-tree (root dir)",
    },
    { "<leader>E", "<cmd>neo-tree toggle<CR>", desc = "neo-tree (cwd)" },
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
      follow_current_file = true,
    },
    window = {
      -- :h neo-tree-mappings
      mappings = {
        S = "noop",
        v = { "open_vsplit" },
        s = { "open_split" },
        -- P = "noop",
        -- o = "toggle_preview",
        o = "open",
        ["<Cr>"] = "open_with_window_picker",
        w = "noop",
      },
    },
  },
}
