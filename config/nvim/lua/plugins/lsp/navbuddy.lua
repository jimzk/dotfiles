-- NOTE: experimental
return {
  -- Symbol popup for operation
  "SmiteshP/nvim-navbuddy",
  event = "VeryLazy",
  dependencies = {
    "neovim/nvim-lspconfig",
    "SmiteshP/nvim-navic",
    "MunifTanjim/nui.nvim",
    "numToStr/Comment.nvim", -- Optional
    "nvim-telescope/telescope.nvim", -- Optional
  },
  keys = {
    {
      "<leader>yn",
      "<CMD>Navbuddy<CR>",
      desc = "Select Symbols (Navbuddy)",
      remap = true,
    },
  },
  opts = function()
    local actions = require("nvim-navbuddy.actions")
    return {
      window = {
        size = "90%",
        sections = {
          left = {
            size = "20%",
          },
          mid = {
            size = "30%",
          },
        },
      },

      lsp = {
        -- ISSUE: can't open symbols for dependency source, notify "No lsp servers attached"
        auto_attach = true,
      },
      mappings = {
        ["?"] = actions.help(),
        ["<M-i>"] = actions.close(),
      },
    }
  end,
}
