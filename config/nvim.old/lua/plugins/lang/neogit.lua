return {
  "NeogitOrg/neogit",
  event = "VeryLazy",
  keys = {
    {
      "<leader>I",
      "<cmd>Neogit kind=vsplit<cr>",
      desc = "git operations (neogit)",
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
        --     ["<space>"] = "Toggle",
        --     ["<tab>"] = "",
      }
    },
  },
}
