-- Override: https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/plugins/editor.lua#L481
return {
  "folke/todo-comments.nvim",
  cmd = { "TodoTrouble", "TodoTelescope" },
  event = "LazyFile",
  -- If keys is a function, then it override but not merge with the default keys
  keys = function()
    return {
      {
        "<leader>mtf",
        function()
          local path = vim.fn.expand("%:p")
          vim.cmd("TodoTrouble cwd=" .. path)
        end,
        desc = "File TODOs",
      },
      { "<leader>mtw", "<cmd>TodoTrouble<cr>", desc = "Workspace TODOs" },
      { "<leader>mtW", "<cmd>TodoTelescope<cr>", desc = "Workspace TODOs (Telescope)" },
      -- {
      --   "<leader>mf",
      --   function()
      --     local path = vim.fn.expand("%:p")
      --     vim.cmd("TodoTelescope cwd=" .. path)
      --   end,
      --   desc = "TODO in Current File (Telescope)",
      -- },
      {
        "<leader>mff",
        function()
          local path = vim.fn.expand("%:p")
          vim.cmd("TodoTrouble cwd=" .. path)
        end,
        desc = "File TODO/FIX",
      },
      { "<leader>mfw", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Workspace TODO/FIX" },
      {
        "<leader>mfW",
        "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",
        desc = "Workspace TODO/FIX (Telescope)",
      },
    }
  end,
  opts = {
    keywords = {
      TODO = { color = "#8caaef" },
    },
    highlight = {
      keyword = "bg",
    },
  },
  config = function(_, opts)
    local todo_comments = require("todo-comments")
    todo_comments.setup(opts)
    local next_todo_repeat, prev_todo_repeat =
      Util.make_repeatable_move_pair(todo_comments.jump_next, todo_comments.jump_prev)
    local map = Util.map
    map({ "n", "x", "o" }, "]t", next_todo_repeat, "Next TODO")
    map({ "n", "x", "o" }, "[t", prev_todo_repeat, "Prev TODO")
    require("which-key").register({
      ["<leader>m"] = {
        t = { name = "TODO" },
        f = { name = "TODO/FIX" },
      },
    })
  end,
}
