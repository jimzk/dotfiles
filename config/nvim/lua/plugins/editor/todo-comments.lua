-- todo comments
return {
  "folke/todo-comments.nvim",
  event = "VeryLazy",
  cmd = { "TodoTrouble", "TodoTelescope" },
  keys = {
    { "]t", function() require("todo-comments").jump_next() end, desc = "next TODO" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "prev TODO" },
    { "<leader>ft", function()
      local d = vim.fn.expand("%:p")
      vim.cmd("TodoTrouble cwd=" .. d)
    end, desc = "[C] TODOs in current file" },
    { "<leader>fT", "<cmd>TodoTrouble<cr>", desc = "[C] TODOs in workspace" },
    { "<leader>f<C-t>", "<cmd>TodoTelescope<cr>", desc = "TODOs Telescope" },
  },
  opts = {
    signs = false,
  }
}
