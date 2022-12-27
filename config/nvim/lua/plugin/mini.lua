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
    goto_left = 'g[',
    goto_right = 'g]',
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

-- -- Wrap function to change jumplist
-- MiniAi.expr_textobject = (function(func)
--   return function(...)
--     -- Visual selection is char if using ib{
--     local cursor = vim.api.nvim_win_get_cursor(0)
--     -- vim.api.nvim_buf_set_mark(0, "`", cursor[1], cursor[2], {})

--     -- Can't work. ai won't update <>
--     -- local left_pos = vim.api.nvim_buf_get_mark(0, "<")
--     -- local right_pos = vim.api.nvim_buf_get_mark(0, ">")
--     -- if left_pos[1] == right_pos[1] and left_pos[2] == right_pos[2] then
--     --   local mode = vim.api.nvim_get_mode().mode
--     --   local cursor = vim.api.nvim_win_get_cursor(0)
--     --   vim.fn.setreg("+", dump(left_pos) .. dump(cursor) .. ", " .. mode)
--     --   vim.api.nvim_buf_set_mark(0, "a", cursor[1], cursor[2], {})
--     -- end
--     return func(...)
--   end
-- end)(MiniAi.expr_textobject)

-- mini.indentscope aminates a *blue guide line* to indicate indent scope.
-- ii and ai select what the line indicates.
require('mini.indentscope').setup {
  draw = {
    delay = 0,
  }
}
