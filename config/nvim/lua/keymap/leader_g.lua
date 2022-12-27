local builtin = require("telescope.builtin")
local opts = { prefix = "<leader>g", silent = true }
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
  b = { "<cmd>lua require('gitsigns').blame_line{full=true}<cr>", "line blame" },
  ["<C-b>"] = { function()
    vim.cmd [[Gitsigns toggle_current_line_blame]]
    vim.notify [[Toggle inline Git blame]]
  end, "toggle line blame" },
  -- diffview
  h = { "<cmd>DiffviewFileHistory %<cr>", "file commits" },
  H = { "<cmd>DiffviewFileHistory<cr>", "all commits" },
  D = { function()
    vim.cmd [[DiffviewOpen]]
    vim.cmd [[sleep 60m]] -- wait cursur to be located
    vim.cmd [[DiffviewToggleFiles]]
    vim.cmd [[wincmd l]]
  end, "current file diff" },
  d = { "<cmd>DiffviewOpen<cr><cmd>wincmd l<cr><cmd>wincmd l<cr>", "all files diff" },
  -- fugitive
  ["<M-d>"] = { "<cmd>Gvdiffsplit<cr>", "current file diff" },
  B = { "<cmd>Git blame<cr>", "file blame" },
  g = { "<cmd>Git<cr>", "git status and operations" },
  -- telescope
  l = { function()
    vim.g.bcommits_file_path = vim.fn.expand("%:p") -- my previewers need it
    builtin.git_bcommits()
  end, "file commits (telescope)" },
  L = { builtin.git_commits, "all commits (telescope)" },
  s = { builtin.git_stash, "list stashes" },
  r = { builtin.git_branches, "branches" },
}, opts)

require("which-key").register({
  h = { function()
    vim.cmd [[normal! gv]]
    vim.cmd [['<,'>DiffviewFileHistory]]
    vim.notify("Commit history on selected lines")
  end, "file commits", mode = "v" },
}, opts)

vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = "Git change" })
