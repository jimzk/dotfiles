-- todo comments
return {
  "folke/todo-comments.nvim",
  event = "VeryLazy",
  cmd = { "TodoTrouble", "TodoTelescope" },
  keys = {
    { "]t", function() require("todo-comments").jump_next() end, desc = "next TODO" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "prev TODO" },
    { "gt", function()
      local d = vim.fn.expand("%:p")
      vim.cmd("TodoTrouble cwd=" .. d)
    end, desc = "[C] TODOs" },
    { "gT", "<cmd>TodoTrouble<cr>", desc = "[C] TODOs in workspace" },
    { "g<C-t>", "<cmd>TodoTelescope<cr>", desc = "TODOs Telescope" },
  },
  opts = {
    signs = false,
  }
}
