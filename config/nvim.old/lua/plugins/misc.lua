return {
  -- measure startuptime
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },

  -- Improve startup time
  -- { -- Lazy.nvim doesn't need it
  --   "lewis6991/impatient.nvim",
  --   enable = false,
  --   config = function()
  --     require("impatient").enable_profile() -- Enable :LuaCacheProfile
  --   end,
  -- },

  -- library used by other plugins
  "nvim-lua/plenary.nvim",
}
