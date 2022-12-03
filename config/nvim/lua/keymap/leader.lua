local wk = require("which-key")

wk.register({
  w = { "camelCase w", mode = { "n", "v", "o" } },
  b = { "camelCase b", mode = { "n", "v", "o" } },
  e = { "camelCase e", mode = { "n", "v", "o" } },
  ["ge"] = { "camelCase ge", mode = { "n", "v", "o" } },
  ["<leader>"] = { "<cmd>Telescope resume<cr>", "Last telescope history" },
  ["<C-space>"] = { "<cmd>Telescope pickers<cr>", "All telescope history" },
  ["["] = "add blank line up",
  ["]"] = "add blank line down",
  d = { [[V"vY'>"vp]], "duplicate line" },
  l = { "<cmd>noh<cr>", "clear search highlight" },
  a = { "<cmd>Gitsigns stage_hunk<cr>", "add (stage) current change", mode = { "n", "v" } },
  A = { "<cmd>Gitsigns stage_buffer<cr>", "add (stage) current buffer" },
}, { prefix = "<leader>" })

wk.register({
  d = { [["vY'>"vp]], "duplicate lines" },
}, { prefix = "<leader>", mode = "v" })
