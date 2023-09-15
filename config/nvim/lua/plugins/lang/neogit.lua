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
    integrations = {
      diffview = true,
    },
    sections = {
      untracked = {
        folded = true,
      },
    }
    -- mappings = {
    --   status = {
    --     ["<space>"] = "Toggle",
    --     ["<tab>"] = "",
    --   }
    -- },
  },
}
