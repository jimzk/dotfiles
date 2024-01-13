-- NOTE: experimental plugin
return {
  -- Buffer navigation
  -- ISSUE: if you stop to press then it jumps to buffer. This behavior is not like regular <C-tab>. I don't like
  "ghillb/cybu.nvim",
  event = "VeryLazy",
  keys = {
    { "<M-h>", "<Plug>(CybuLastusedPrev)", desc = "Prev Used Buffer" },
    { "<M-l>", "<Plug>(CybuLastusedNext)", desc = "Next Used Buffer" },
    { "<M-S-h>", "<Plug>(CybuPrev)", desc = "Prev Used Buffer" },
    { "<M-S-l>", "<Plug>(CybuNext)", desc = "Next Used Buffer" },
  },
  opts = {
    behavior = { -- set behavior for different modes
      mode = {
        last_used = {
          switch = "immediate", -- immediate, on_close
          view = "paging", -- paging, rolling
        },
      },
    },
    display_time = 500,
  },
}
