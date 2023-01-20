return {
  "rmagatti/auto-session",
  event = "VeryLazy",
  dependencies = {
    "rmagatti/session-lens"
  },
  opts = {
    auto_session_create_enabled = false,
    -- auto_session_enable_last_session
  },
  config = function(_, opts)
    require("auto-session").setup(opts)
    require('session-lens').setup {}
    require("telescope").load_extension("session-lens")
  end
}
