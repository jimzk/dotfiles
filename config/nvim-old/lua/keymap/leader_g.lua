local builtin = require("telescope.builtin")
local opts = { prefix = "<leader>g", silent = true }
require("which-key").register({
  name = "git",
  -- c = { "<cmd>Gitsigns preview_hunk<cr>", "preview current change" },
  -- c = { "<cmd>Gitsigns setqflist<cr>", "preview all changes in quickfix" },
  -- b = { "<cmd>lua require('gitsigns').blame_line{full=true}<cr>", "line blame" },
  -- ["<C-b>"] = { function()
  --   vim.cmd [[Gitsigns toggle_current_line_blame]]
  --   vim.notify [[Toggle inline Git blame]]
  -- end, "toggle line blame" },
  -- diffview
  -- h = { "<cmd>DiffviewFileHistory %<cr>", "file commits" },
  -- H = { "<cmd>DiffviewFileHistory<cr>", "all commits" },
  -- D = { function()
  --   vim.cmd [[DiffviewOpen]]
  --   vim.cmd [[sleep 60m]] -- wait cursur to be located
  --   vim.cmd [[DiffviewToggleFiles]]
  --   vim.cmd [[wincmd l]]
  -- end, "current file diff" },
  -- d = { "<cmd>DiffviewOpen<cr><cmd>wincmd l<cr><cmd>wincmd l<cr>", "all files diff" },
  -- fugitive
  -- ["<M-d>"] = { "<cmd>Gvdiffsplit<cr>", "current file diff" },
  -- B = { "<cmd>Git blame<cr>", "file blame" },
  -- g = { "<cmd>Git<cr>", "git status and operations" },
  -- telescope
  -- l = { function()
  --   vim.g.bcommits_file_path = vim.fn.expand("%:p") -- my previewers need it
  --   builtin.git_bcommits()
  -- end, "file commits (telescope)" },
  -- L = { builtin.git_commits, "all commits (telescope)" },
  -- s = { builtin.git_stash, "list stashes" },
  -- r = { builtin.git_branches, "branches" },
}, opts)
