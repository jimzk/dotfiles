-- todo comments
return {
  "folke/todo-comments.nvim",
  event = "VeryLazy",
  cmd = { "TodoTrouble", "TodoTelescope" },
  keys = {
    {
      "gt",
      function()
        local d = vim.fn.expand("%:p")
        vim.cmd("TodoTrouble cwd=" .. d)
      end,
      desc = "[C] TODOs in current file",
    },
    { "gT", "<cmd>TodoTrouble<cr>", desc = "[C] TODOs in workspace" },
    { "g<C-t>", "<cmd>TodoTelescope<cr>", desc = "TODOs Telescope" },
  },
  opts = {
    signs = false,
  },
  config = function(_, opts)
    local todo_comments = require("todo-comments")
    todo_comments.setup(opts)
    local next_todo_repeat, prev_todo_repeat =
      Util.make_repeatable_move_pair(todo_comments.jump_next, todo_comments.jump_prev)
    map({ "n", "x", "o" }, "]t", next_todo_repeat, "next TODO")
    map({ "n", "x", "o" }, "[t", prev_todo_repeat, "prev TODO")
  end,
}
