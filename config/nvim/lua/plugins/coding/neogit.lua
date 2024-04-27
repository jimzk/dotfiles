return {
  "NeogitOrg/neogit",
  event = "BufReadPost",
  branch = "nightly",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      "<leader>ggg",
      "<cmd>Neogit kind=vsplit<cr>",
      desc = "Git (neogit)",
    },
  },
  opts = {
    sections = {
      untracked = {
        folded = true,
      },
    },
    mappings = {
      status = {
        ["<esc>"] = "Close",
        -- ["<leader>i"] = "Close",
        --     ["<space>"] = "Toggle",
        --     ["<tab>"] = "",
      },
    },
  },
}
