return {
  -- keep good vim habits
  "m4xshen/hardtime.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
  },
  enabled = false,
  opts = {
    max_count = 5,
  },
  config = function(_, opts)
    require("hardtime").setup(opts)
    vim.g.hardtime_disabled = false
    vim.keymap.set("n", "<leader>oH", function()
      Util.toggle(not vim.g.hardtime_disabled, function()
        vim.cmd("Hardtime toggle")
        vim.g.hardtime_disabled = not vim.g.hardtime_disabled
      end, "Haradtime")
    end, { desc = "Toggle Hardtime" })
  end,
}
