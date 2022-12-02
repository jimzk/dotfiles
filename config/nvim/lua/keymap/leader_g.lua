local builtin = require("telescope.builtin")

require("which-key").register({
  name = "git",
  -- gitsigns
  a = { "<cmd>Gitsigns stage_hunk<cr>", "add (stage) current change", mode = { "n", "v" } },
  A = { "<cmd>Gitsigns stage_buffer<cr>", "add (stage) current buffer" },
  x = { "<cmd>Gitsigns undo_stage_hunk<cr>", "unstage change" },
  U = { "<cmd>Gitsigns reset_buffer<cr>", "revert buffer" },
  u = { "<cmd>Gitsigns reset_hunk<cr>", "revert change", mode = { "n", "v" } },
  c = { "<cmd>Gitsigns preview_hunk<cr>", "preview change" },
  C = { "<cmd>Gitsigns toggle_deleted<cr><cmd>Gitsigns toggle_linehl<cr>", "preview all changes (toggle)" },
  b = { "<cmd>lua require('gitsigns').blame_line{full=true}<cr>", "inline blame" },
  d = { "<cmd>Gitsigns diffthis<cr>", "diff" },
  -- fugitive
  B = { "<cmd>Git blame<cr><cmd>echo '[git blame] g? for help'<cr>", "file blame" },
  g = { function()
    vim.cmd("Git")
    vim.keymap.set("n", "q", ":q<cr>", { buffer = true, silent = true })
  end, "git status and operations" },
  -- telescope
  l = { function() builtin.git_bcommits({
      layout_strategy = "vertical",
      layout_config = {
        width = 140,
      },
      prompt_title = "Git Commits on Current Buffer",
      results_title = "|checkout: ⏎ |diff: ^v(split) ^s(plit) ^t(ab)",
      -- TODO: reorder previewers
      -- preview cmd: git -c delta.paging=never diff <git_ref> <path>
      -- ref: telescope.nvim/lua/telescope/builtin/__git.lua, search git.bcommits
      -- previewer = {
      --   require'telescope.previewers'.git_commit_diff_to_parent.new(),
      --   require'telescope.previewers'.git_commit_diff_to_head.new(),
      --   require'telescope.previewers'.git_commit_diff_as_was.new(),
      --   require'telescope.previewers'.git_commit_message.new(),
      -- },
    })
  end, "commits on current buffer" },
  L = { function() builtin.git_commits({
      layout_strategy = "vertical",
      layout_config = {
        width = 140,
      },
      prompt_title = "Git Commits on Repo",
      results_title = "|checkout: ⏎ |diff: ^v(split) ^s(plit) ^t(ab)",
    })
  end, "commits on repo" },
  t = { function() builtin.git_stash({
      layout_strategy = "vertical",
      layout_config = {
        width = 140,
      },
      prompt_title = "Git Stash",
      results_title = "apply ⏎",
    })
  end, "stashes" },
  r = { function() builtin.git_branches({
      layout_strategy = "vertical",
      layout_config = {
        width = 0.9,
        preview_height = 0.35,
      },
      wrap_results = false,
      prompt_title = "Git Branch",
      results_title = "|checkout: ⏎ |new: ^a |rebase: ^t |delete: ^d |merge: ^y |track: ^t",
    })
  end, "branches" },
}, { prefix = "<leader>g" })

require("which-key").register({
  ["ih"] = { "<cmd>Gitsigns select_hunk<cr>", "select git change", mode = { "o", "v" } },
}, { prefix = "" })
