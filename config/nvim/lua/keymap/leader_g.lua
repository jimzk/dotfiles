local builtin = require("telescope.builtin")

require("which-key").register({
  name = "git",
  -- gitsigns
  -- a = { "<cmd>Gitsigns stage_hunk<cr>", "add (stage) current change", mode = { "n", "v" } },
  -- A = { "<cmd>Gitsigns stage_buffer<cr>", "add (stage) current buffer" },
  -- x = { "<cmd>Gitsigns undo_stage_hunk<cr>", "unstage current change" },
  -- U = { "<cmd>Gitsigns reset_buffer<cr>", "revert buffer" },
  -- u = { "<cmd>Gitsigns reset_hunk<cr>", "revert current change", mode = { "n", "v" } },
  -- c = { "<cmd>Gitsigns preview_hunk<cr>", "preview current change" },
  q = { "<cmd>Gitsigns setqflist<cr>", "preview all changes in quickfix" },
  h = { function()
    vim.cmd [[Gitsigns toggle_deleted]]
    vim.cmd [[Gitsigns toggle_word_diff]]
    Notify [[Toggle highlight on Git deletion and diffs]]
  end, "toggle highlight of changes" },
  b = { "<cmd>lua require('gitsigns').blame_line{full=true}<cr>", "line blame" },
  ["<C-b>"] = { function()
    vim.cmd [[Gitsigns toggle_current_line_blame]]
    Notify [[Toggle inline Git blame]]
  end, "toggle line blame" },
  -- fugitive
  d = { function()
    vim.cmd [[Gvdiffsplit]]
    vim.keymap.set("n", "q", ":q<cr>zz", { buffer = true, silent = true })
  end, "current file diff" },
  B = { function()
    vim.cmd [[Git blame]]
    Notify("g? for help")
  end, "file blame" },
  g = { "<cmd>Git<cr>", "git status and operations" },
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
  end, "list stashes" },
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

vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
