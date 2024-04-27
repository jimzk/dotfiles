return {
  -- Enhance gx to open URL, github repo, issue ...
  "chrishrb/gx.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = { "BufEnter" },
  keys = {
    { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } },
  },
  init = function()
    vim.g.netrw_nogx = 1 -- disable netrw gx
  end,
  opts = {
    handlers = {
      rust = { -- custom handler to open rust's cargo packages
        name = "rust", -- set name of handler
        filetype = { "toml" }, -- you can also set the required filetype for this handler
        filename = "Cargo.toml", -- or the necessary filename
        handle = function(mode, line, _)
          local crate = require("gx.helper").find(line, mode, "(%w+)%s-=%s")
          if crate then
            return "https://crates.io/crates/" .. crate
          end
        end,
      },
    },
  },
}
