local builtin = require("telescope.builtin")
local extensions = require("telescope").extensions
local themes = require("telescope.themes")
local wk = require("which-key")

wk.register({
  name = "fuzzy search",
  -- find file
  f = { function()
    builtin.find_files({
      prompt_title = "Find File In Working Directory",
      results_title = "|open: ^v(split) ^s(plit) ^t(ab)",
      follow = true,
      hidden = true,
    })
  end, "files in working directory" },
  F = { function()
    builtin.find_files({
      prompt_title = "Find File In My Space",
      results_title = "|open: ^v(split) ^s(plit) ^t(ab)",
      search_dirs = { '~/workspace', '~/Desktop', "~/.config", "~/go", "~/Downloads" },
      follow = true,
      hidden = true,
    })
  end, "files in my space" },
  o = { function()
    extensions.frecency.frecency({ -- repalce oldfiles with frecency
      results_title = "|open: ^v(split) ^s(plit) ^t(ab) |search tag: :plug:",
      prompt_title = "Find Recently Opened File",
      previewer = false,
    })
  end, "recent files" },
  -- find project
  p = { function()
    extensions.projects.projects(themes.get_dropdown {
      layout_strategy = "horizontal",
      layout_config = {
        width = { 0.95, max = 100 },
      },
      -- FIX: <c-b> not working
      -- https://github.com/ahmedkhalf/project.nvim/issues/74
      results_title = "|file: ^r(recent) <cr>(find) ^s(search) ^b(browse) |remove: ^d |change PWD: ^w",
      prompt_title = "Recent Projects",
    })
  end, "recent projects" },
  s = { "<cmd>SearchSession<cr>", "recent projects (auto-session)" },
  P = { function()
    extensions.project.project(themes.get_dropdown {
      results_title = "|file: ^r(recent) <cr>(find) ^s(search) ^b(browse) |rename: ^v |change PWD: ^l",
      layout_strategy = "horizontal",
      layout_config = {
        width = { 0.95, max = 100 },
      },
      prompt_title = "All Projects",
    })
  end, "open project" },

  -- find git file
  G = { function() builtin.git_files({
      results_title = "|open ^v(split) ^s(plit) ^t(ab)",
      prompt_title = "Find Git File",
    })
  end, "git files" },
  g = { function() builtin.git_status({
      results_title = "|(un)stage: ⇥ |open: ^v(split) ^s(plit) ^t(ab)",
      prompt_title = "Find Git Changed File",
    })
  end, "changed git files" },
  t = { "<cmd>Telescope current_buffer_tags<cr>", "tags in current buffer" },
  T = { "<cmd>Telescope tags<cr>", "tags in project" },
}, { prefix = "<leader>f" })
