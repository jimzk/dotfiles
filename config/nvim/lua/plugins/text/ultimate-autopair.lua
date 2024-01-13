local M = {
  -- A out-of-box autopair plugins.
  "altermo/ultimate-autopair.nvim",
  event = { "InsertEnter", "CmdlineEnter" },
  enabled = false,
  -- dependencies = {
  --   { "windwp/nvim-autopairs", enabled = false },
  --   { "abecodes/tabout.nvim", enabled = true },
  -- },
  branch = "v0.6",
}

M.opts = {
  internal_pairs = {
    { "<", ">", fly = true, dosuround = true, space = true, ft = { "rust" } },
  },
  -- Configure existing pairs in require("ultimate-autopair.default").conf
  config_internal_pairs = {
    { "'", "'", nft = { "rust" } },
  },
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
}

M.config = function(_, opts)
  local default_opts = require("ultimate-autopair.default").conf
  vim.list_extend(opts.internal_pairs, default_opts.internal_pairs)
  require("ultimate-autopair").setup(opts)
end

return M
