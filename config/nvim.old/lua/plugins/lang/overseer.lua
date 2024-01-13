return {
  -- Run frequently-used tasks in background
  "stevearc/overseer.nvim",
  keys = {
    { "<leader>co", "<cmd>OverseerRun<cr><cmd>OverseerOpen<cr>", desc = "build/run (Overseer)" },
    { "<leader>cO", "<cmd>OverseerToggle<cr>", desc = "toggle build/run result (Overseer)" },
  },
  opts = {
    task_list = {
      direction = "bottom",
      max_width = { 250, 0.5 },
      min_width = { 100, 0.2},
      max_height = { 100, 0.3 },
      bindings = {
        ["<C-l>"] = false,
        ["<C-h>"] = false,
        ["l"] = "IncreaseDetail",
        ["h"] = "DecreaseDetail",
        ["<C-j>"] = false,
        ["<C-k>"] = false,
        ["K"] = "ScrollOutputUp",
        ["J"] = "ScrollOutputDown",
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
