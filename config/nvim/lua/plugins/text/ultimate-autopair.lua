return {
  -- A out-of-box autopair plugins. No need much configuration. I like it.
  "altermo/ultimate-autopair.nvim",
  event = { "InsertEnter", "CmdlineEnter" },
  enabled = true,
  dependencies = {
    { "windwp/nvim-autopairs", enabled = false },
    { "abecodes/tabout.nvim", enabled = true },
  },
  branch = "v0.6",
  opts = {
    -- <M-e> for fastwrap
    fastwrap = {
      enabled = true,
    },
    space2 = {
      enable = true,
    },
    tabout = {
      enable = false, -- I use   "abecodes/tabout.nvim",
    },
    extensions = {
      -- Performance issue: https://github.com/altermo/ultimate-autopair.nvim/issues/74
      filetype = { tree = false },
      utf8 = false,
      alpha = {
        -- alpha = true, -- Disable autopair if the prev char is alpha
        after = true, -- Disable autopair if the next char is alpha
      },
      cmdtype = {
        skip = { "/", "?", "@", "-", ":" }, -- Disable autopair for cmd
      },
      cond = false, -- ISSUE: affect performance
      -- What fly does?
      -- press ) for ({[*] }) -> ({[] })*
      -- press ) for *() -> ()*
      fly = {
        fly = true,
      },
    },
  },
}
