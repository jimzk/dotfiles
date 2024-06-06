return {
  "echasnovski/mini.operators",
  opts = {
    evaluate = {
      prefix = "s=",
    },
    exchange = {
      prefix = "se",
    },
    multiply = {
      prefix = "sd",
    },
    replace = {
      prefix = "",
    },
    sort = {
      prefix = "ss",
    },
  },
  config = function(_, opts)
    require("mini.operators").setup(opts)
    -- vim.keymap.del("n", "<leader>D>") -- Default mapping
    -- vim.keymap.set("n", "<leader>D<leader>D", "<leader>D_", { remap = true, desc = "Duplicate Line" })
    vim.keymap.set("n", "sc", "sddkgccj", { remap = true, desc = "Duplicate Line and Comment" })
    vim.keymap.set("v", "sc", "sdgvgcj", { remap = true, desc = "Duplicate Lines and Comment" })

    WhichKey.register({
      ["ssp="] = { desc = "Evaluate Math Expression (Operator)" },
      ["se"] = { desc = "Exchange Text (Operator)" },
      ["sd"] = { desc = "Duplicate Text (Operator)" },
      ["ss"] = { desc = "Sort Text (Operator)" },
    })

    vim.cmd([[hi! link MiniOperatorsExchangeFrom CurSearch]])
  end,
}
