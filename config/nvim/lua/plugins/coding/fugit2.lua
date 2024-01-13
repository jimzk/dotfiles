return {
  "SuperBo/fugit2.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
    "nvim-lua/plenary.nvim",
    {
      "chrisgrieser/nvim-tinygit",
      dependencies = { "stevearc/dressing.nvim" },
    },
  },
  cmd = { "Fugit2", "Fugit2Graph" },
  keys = {
    -- keymaps
    -- * - stage/unstage
    -- * = status view
    -- * menu: c commit, b branch, d diff, f fetch, p pull, P push, N GitHub
    { "<M-g>", mode = "n", "<cmd>Fugit2<cr>", desc = "Git Status (fugit2)" },
  },
  opts = {},
}
