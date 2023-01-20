local wk = require("which-key")
local opt = { mode = "n", prefix = "<leader>", noremap = true, silent = true }
wk.register({
  -- w = { "<cmd>w<cr>", "write" },
  -- W = { function()
  --   vim.cmd [[wa]]
  --   vim.notify("Write all!")
  -- end, "write all" },
  ["<space>"] = { "<cmd>Gitsigns preview_hunk<cr>", "[G] preview current change" },
  ["<tab>"] = { "<cmd>Telescope resume<cr>", "last telescope history" },
  ["<S-tab>"] = { "<cmd>Telescope pickers<cr>", "All telescope history" },
  a = { "<cmd>Gitsigns stage_hunk<cr>", "[G] stage current hunk" },
  A = { "<cmd>Gitsigns stage_buffer<cr>", "[G] stage buffer" },
  ["<C-a>"] = { "<cmd>Gitsigns undo_stage_hunk<cr>", "[G] undo staged hunk" },
  u = { "<cmd>Gitsigns reset_hunk<cr>", "[G] revert current change" },
  U = { "<cmd>Gitsigns reset_buffer<cr>", "[G] revert buffer" },
  l = { function()
    vim.lsp.buf.format { async = false }
    vim.cmd [[silent w]] -- Save after format
  end, "format file (by lsp)", mode = { "n", "v" } },
  d = { [[V"vY'>"vp]], "duplicate line" },
  r = { function()
    require('spectre').open_file_search()
  end, "search and repalce (spectre)" },
}, opt)

wk.register({
  d = { [["vY'>"vp]], "duplicate lines", mode = "v" },
  r = { function()
    vim.cmd('noau normal! "vy"')
    local content = vim.fn.getreg('v')
    local path = vim.fn.fnameescape(vim.fn.expand('%:p:.'))
    require("spectre").open {
      search_text = content,
      path = path,
    }
  end, "search and replace (spectre)", mode = "v" },
}, opt)

wk.register({
  ["<M-u>"] = { "<cmd>Gitsigns reset_hunk<cr>", "[G] revert current change" },
  ["<M-S-u>"] = { "<cmd>Gitsigns reset_buffer<cr>", "[G] revert buffer" },
}, { mode = "n" })
