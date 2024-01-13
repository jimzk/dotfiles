return {
  -- A harpoon-like file management
  "cbochs/grapple.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "VeryLazy",
  keys = {
    { "<leader>'", "<CMD>GrappleToggle<CR>", desc = "Toggle File in Grapple" },
    { "<leader>;", "<CMD>GrapplePop tags<CR>", desc = "Popup Window for Grapple" },
    { "<leader>]", "<CMD>GrappleCycle backward<CR>", desc = "Prev File in Grapple" },
    { "<leader>[", "<CMD>GrappleCycle forward<CR>", desc = "Next File in Grapple" },
  },
  opts = {},
}
