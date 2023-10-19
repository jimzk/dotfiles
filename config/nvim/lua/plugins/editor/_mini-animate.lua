return {
  -- Smooth scrolling
  "echasnovski/mini.animate",
  event = "VeryLazy",
  config = function()
    local animate = require("mini.animate")
    animate.setup({
      scroll = {
        enable = true,
        -- Speed up animation to avoid lagging
        timing = require("mini.animate").gen_timing.linear({ duration = 150, unit = "total" }),
      },
      cursor = {
        enable = false,
      },
      open = {
        enable = false,
      },
      close = {
        enable = false,
      },
      resize = {
        enable = false,
      },
    })
  end,
}
