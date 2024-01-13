return {
  "rainbowhxch/accelerated-jk.nvim",
  opts = {},
  config = function(_, opts)
    require("accelerated-jk").setup(opts)
    vim.defer_fn(function()
      vim.keymap.set({ "n" }, "j", "<Plug>(accelerated_jk_gj)")
      vim.keymap.set({ "n" }, "k", "<Plug>(accelerated_jk_gk)")
      -- vim.keymap.set({ "n" }, "<Down>", "<Plug>(accelerated_jk_gj)")
      -- vim.keymap.set({ "n" }, "<Up>", "<Plug>(accelerated_jk_gk)")
    end, 500)
  end,
}
