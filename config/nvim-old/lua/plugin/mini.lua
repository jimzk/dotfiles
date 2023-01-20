require("mini.ai").setup {
  mappings = {
    -- Main textobject prefixes
    around = 'a',
    inside = 'i',

    -- Next/last textobjects
    around_next = 'an',
    inside_next = 'in',
    around_last = 'aN',
    inside_last = 'iN',

    -- Move cursor to corresponding edge of `a` textobject
    goto_left = '[',
    goto_right = ']',
  },

  -- Number of lines within which textobject is searched
  n_lines = 500,

  custom_textobjects = {
    -- let b includes <..>
    -- b = { { '%b()', '%b[]', '%b{}', '%b<>' }, '^.().*().$' },
    b = { { '%b()' }, '^.().*().$' },
    B = { { '%b{}' }, '^.().*().$' },
    k = { { '%b<>' }, '^.().*().$' },
    r = { { '%b[]' }, '^.().*().$' },
    ["?"] = false, -- Disable prompt ask motion
  },
  search_method = 'cover_or_next',
}

-- mini.indentscope aminates a *blue guide line* to indicate indent scope.
-- ii and ai select what the line indicates.
require('mini.indentscope').setup {
  draw = {
    delay = 1,
    -- Disable slow animation
    animation = function(_, _) return 0 end,
  },
}

-- Disable for certain types
vim.api.nvim_create_autocmd('FileType', {
  pattern = Utils.non_code_filetypes,
  callback = function()
    vim.b.miniindentscope_disable = true
  end
})

-- I try to hook function to jump back after surrounding but failed. Give up to use it.
-- require('mini.surround').setup { }
