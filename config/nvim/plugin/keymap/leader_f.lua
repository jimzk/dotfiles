
local builtin = require("telescope.builtin")

local leader_f = {
  name = "fuzzy search",
  -- find files
  f = {function() builtin.find_files({
    prompt_title = "Find File In Working Directory",
    results_title = "open ^v(split) ^s(plit) ^t(ab)",
    follow = true,
    hidden = true,
  }) end, "files in working directory"},
  F = {function() builtin.find_files({
    prompt_title = "Find File In My Space",
    results_title = "open ^v(split) ^s(plit) ^t(ab)",
    search_dirs = {'~/workspace', '~/Desktop', "~/.config", "~/go", "~/Downloads"},
    follow = true,
    hidden = true,
  }) end, "files in my space"},
  r = {function() builtin.oldfiles({
    results_title = "open ^v(split) ^s(plit) ^t(ab)",
    prompt_title = "Find Recently Opened File",
  }) end, "recently opened files"},
  b = {function() builtin.buffers(require("telescope.themes").get_ivy{
    prompt_title = "Find Buffer",
    results_title = "open ^v(split) ^s(plit) ^t(ab)",
    layout_config = {
      preview_width = 0.75,
    },
    sort_lastused = true,
  }) end, "buffers"},

  -- find git files
  g = {function() builtin.git_files({
    results_title = "open ^v(split) ^s(plit) ^t(ab)",
    prompt_title = "Find Git File",
  }) end, "git files"},
  c = {function() builtin.git_status({
    results_title = "(un)stage ⇥, open ^v(split) ^s(plit) ^t(ab)",
    prompt_title = "Find Git Changed File",
  }) end, "changed git files"},

  -- grep line
  l = {function() builtin.live_grep({
    prompt_title = "Grep Line In Current Buffer",
    search_dirs = {vim.fn.expand('%'),},

    layout_strategy = "vertical",
    layout_config = {
      preview_height = 0.4,
      width = 140,
    },
    wrap_results = false,
  }) end, "grep line in current buffer"},
  L = {function() builtin.live_grep({
    prompt_title = "Grep Line In Buffers",
    grep_open_files = true,

    layout_strategy = "vertical",
    layout_config = {
      preview_height = 0.4,
      width = 140,
    },
    wrap_results = false,
  }) end, "grep line in buffers"},
  [";"] = {function() builtin.live_grep({
    prompt_title = "Grep Line In Working Directory",

    layout_strategy = "vertical",
    layout_config = {
      preview_height = 0.4,
      width = 140,
    },
    wrap_results = false,
  }) end, "grep line in working directory"},

  -- jumplist
  j = {function() builtin.jumplist({
    prompt_title = "Jumplist",
    -- trim_text = true,
    -- name_width = 100,
    layout_strategy = "vertical",
    layout_config = {
      preview_height = 0.4,
      width = 140,
  }}) end, "location jumplist"},

  t = {"<cmd>Telescope current_buffer_tags<cr>", "tags in current buffer"},
  T = {"<cmd>Telescope tags<cr>", "tags in project"},
}
require("which-key").register(leader_f, {prefix = "<leader>f"})
