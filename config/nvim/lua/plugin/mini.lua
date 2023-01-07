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
    B = { { '%b{}' }, '^.().*().$' },
    ["?"] = false, -- Disable prompt ask motion
  },
  search_method = 'cover',
}

-- mini.indentscope aminates a *blue guide line* to indicate indent scope.
-- ii and ai select what the line indicates.
require('mini.indentscope').setup {
  draw = {
    delay = 50,
  },
}

-- I try to hook function to jump back after surrounding but failed. Give up to use it.
-- require('mini.surround').setup { }
