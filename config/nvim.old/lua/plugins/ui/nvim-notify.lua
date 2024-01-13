-- better vim.notify
return {
  "rcarriga/nvim-notify",
  lazy = false,
  keys = {
    { "<leader>n<BS>", function()
      require("notify").dismiss({
        silent = true,
        pending = true
      })
    end, desc = "dismiss all notify",
    },
  },
  opts = {
    timeout = 2000,
    background_colour = "#24273b",
    max_height = function()
      return math.floor(vim.o.lines * 0.75)
    end,
    max_width = function()
      return math.floor(vim.o.columns * 0.9)
    end
  },
  config = function(_, opts)
    vim.notify = require("notify")
    vim.notify.setup(opts)
  end
}
