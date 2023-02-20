return {
  -- Run frequently-used tasks in background
  "stevearc/overseer.nvim",
  keys = {
    { "<leader>jo", "<cmd>OverseerRun<cr>", desc = "run task (Overseer)" },
    { "<leader>jO", "<cmd>OverseerToggle<cr>", desc = "toggle task result (Overseer)" },
  },
  opts = {
    strategy = "toggleterm",
    task_list = {
      bindings = {
        ["<C-l>"] = false,
        ["<C-h>"] = false,
        ["l"] = "IncreaseDetail",
        ["h"] = "DecreaseDetail",
      }
    },
    task_editor = {
      bindings = {
        n = {
          ["<Esc>"] = "Cancel",
        },
        i = {
          ["<Esc>"] = "Cancel",
          ["<C-/>"] = "ShowHelp",
        }
      }
    }
  },
}
