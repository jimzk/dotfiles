local wk = require("which-key")
local extensions = require("telescope").extensions
local opt = { mode = "n", prefix = "<leader>p", preset = true }
wk.register({
  name = "project",
  s = { "<cmd>SSave!<cr>", "save session" },
  q = { "<cmd>SClose<cr>", "close session" },
  d = { function()
    local session_name = vim.fn.fnamemodify(vim.v.this_session, ':t')
    if session_name == "" then
      vim.notify("No in any session!", vim.log.levels.ERROR)
      return
    end
    vim.cmd("silent SDelete! " .. session_name)
    vim.v.this_session = ""
    vim.notify("Session [" .. session_name .. "] is deleted")
  end, "delete current session" },
  p = { "<cmd>Startify<cr>", "list session" },
  r = { function()
    vim.ui.input(
      { prompt = "Rename current session to: " },
      function(input)
        if not input then
          return
        end
        local old_session_name = vim.fn.fnamemodify(vim.v.this_session, ':t')
        local new_session_name = input
        local session_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/")
        vim.cmd("silent !mv " .. session_dir .. old_session_name .. " " .. session_dir .. new_session_name)
        vim.cmd("SLoad " .. new_session_name)
      end)
  end, "rename session" },
  -- find project
  g = { function()
    -- https://github.com/nvim-telescope/telescope-project.nvim
    extensions.project.project({
      results_title = "|file: ^r(recent) <cr>(find) ^s(search) ^b(browse) |rename: ^v |change cwd: ^l",
      -- layout_strategy = "horizontal",
      layout_config = {
        width = { 0.95, max = 90 },
      },
      prompt_title = "Select A Project",
      display_type = 'minimal', -- or full
    })
  end, "git projects" },
  ["<C-g>"] = { function()
    local path = vim.fn.stdpath("data") .. "/telescope-projects.txt"
    vim.cmd("!rm " .. path)
    vim.notify("Clean telescope-projects cache")
  end, "clean git project cache" },
}, opt)
