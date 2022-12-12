-- https://github.com/chentoast/marks.nvim#setup
require'marks'.setup {
  default_mappings = true,
  -- NOTE: If float buffer of lsp.hover() has marks then it shows signcolumn and can't have enought width
  -- Makr . must be hidden as it always shows in float buffer of lsp.
  builtin_marks = {},
  cyclic = true,
  force_write_shada = false,
  refresh_interval = 250,
  sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
  excluded_filetypes = {},
  mappings = {
    toggle = false,
    -- FIX: need  :q to quite preview window
    -- https://github.com/chentoast/marks.nvim/issues/86
    preview = "m;",
    delete_line = "dm<space>",
    delete_buf = "dm-",
    annotate = false,
  }
}

-- color definied by marks.nvm
vim.cmd("autocmd ColorScheme * highlight link MarkSignNumHL LineNr")
require("marks").toggle_signs()  -- hide mark by default
