return {
  -- Add/replace/delete surrounding. More stable than nvim-surround.
  "echasnovski/mini.surround",
  event = "BufReadPost",
  -- enabled = false,
  opts = {
    mappings = {
      add = "sa",            -- Add surrounding in Normal and Visual modes
      delete = "sd",         -- Delete surrounding
      replace = "sr",        -- Replace surrounding
      update_n_lines = "sn", -- Update `n_lines`
      find = "",             -- Find surrounding (to the right)
      find_left = "",        -- Find surrounding (to the left)
      highlight = "",        -- Highlight surrounding
      suffix_last = "",      -- Suffix to search with "prev" method
      suffix_next = "",      -- Suffix to search with "next" method
    },
  }
}
