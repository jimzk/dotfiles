return {
  "rcarriga/nvim-notify",
  keys = function()
    return {
      {
        "<leader>n<BS>",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss Notifications",
      },
    }
  end,
  opts = {
    timeout = 1000,
  },
}
