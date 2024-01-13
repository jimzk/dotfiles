return {
  "NeogitOrg/neogit",
  event = "BufReadPost",
  keys = {
    {
      "<leader>gg",
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
        ["<leader>i"] = "Close",
        --     ["<space>"] = "Toggle",
        --     ["<tab>"] = "",
      },
    },
  },
}
