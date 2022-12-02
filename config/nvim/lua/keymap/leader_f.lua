local builtin = require("telescope.builtin")
local extensions = require("telescope").extensions
local themes = require("telescope.themes")
local wk = require("which-key")

wk.register({
  name = "fuzzy search",
  -- find file
  f = {function() builtin.find_files({
    prompt_title = "Find File In Working Directory",
    results_title = "|open: ^v(split) ^s(plit) ^t(ab)",
    follow = true,
    hidden = true,
  }) end, "files in working directory"},
  F = {function() builtin.find_files({
    prompt_title = "Find File In My Space",
    results_title = "|open: ^v(split) ^s(plit) ^t(ab)",
    search_dirs = {'~/workspace', '~/Desktop', "~/.config", "~/go", "~/Downloads"},
    follow = true,
    hidden = true,
  }) end, "files in my space"},
  o = {function() extensions.frecency.frecency({  -- repalce oldfiles with frecency
    results_title = "|open: ^v(split) ^s(plit) ^t(ab) |search tag: :plug:",
    prompt_title = "Find Recently Opened File",
    previewer = false,
  }) end, "recent files"},
  -- find project
  p = {function() extensions.projects.projects(themes.get_dropdown{
    layout_strategy = "horizontal",
    layout_config = {
      width = {0.95, max = 100},
    },
    -- FIX: <c-b> not working
    -- https://github.com/ahmedkhalf/project.nvim/issues/74
    results_title = "|file: ^r(recent) <cr>(find) ^s(search) ^b(browse) |remove: ^d |change PWD: ^w",
    prompt_title = "Recent Projects",
  }) end, "recent projects"},
  s = {"<cmd>SearchSession<cr>", "recent projects (auto-session)"},
  P = {function() extensions.project.project(themes.get_dropdown{
    results_title = "|file: ^r(recent) <cr>(find) ^s(search) ^b(browse) |rename: ^v |change PWD: ^l",
    layout_strategy = "horizontal",
    layout_config = {
      width = {0.95, max = 100},
    },
    prompt_title = "All Projects",
  }) end, "find project"},

  -- find git file
  G = {function() builtin.git_files({
    results_title = "|open ^v(split) ^s(plit) ^t(ab)",
    prompt_title = "Find Git File",
  }) end, "git files"},
  g = {function() builtin.git_status({
    results_title = "|(un)stage: ⇥ |open: ^v(split) ^s(plit) ^t(ab)",
    prompt_title = "Find Git Changed File",
  }) end, "changed git files"},

  -- grep line
  -- TODO: how to remember last keyword
  l = {function() builtin.live_grep({
    prompt_title = "Grep Line In Current Buffer",
    search_dirs = {vim.fn.expand('%'),},
  }) end, "grep line in current buffer"},
  ["<C-l>"] = {function() builtin.live_grep({
    prompt_title = "Grep Line In Buffers",
    grep_open_files = true,
  }) end, "grep line in buffers"},
  -- TODO: how to include or exclude file?
  L = {function() extensions.live_grep_args.live_grep_args({
    prompt_title = "Grep Line In Working Directory",
  }) end, "grep line in working directory"},
  [";"] = {function()
    vim.ui.input(  -- vim.
      {prompt = "Enter regex pattern to grep: "},
      function(input)
        builtin.grep_string({
          prompt_title = "Grep Line " .. input .. " In Working Directory",
          use_regex = true,
        })
      end)
 end, "regex grep string in working directory"},

  -- jumplist
  j = {function() builtin.jumplist({
    prompt_title = "Jumplist",
    -- trim_text = true,
    -- name_width = 100,
    layout_strategy = "vertical",
    layout_config = {
      preview_height = 0.4,
      width = 140,
  }}) end, "jumplist"},

  t = {"<cmd>Telescope current_buffer_tags<cr>", "tags in current buffer"},
  T = {"<cmd>Telescope tags<cr>", "tags in project"},
}, {prefix = "<leader>f"})
