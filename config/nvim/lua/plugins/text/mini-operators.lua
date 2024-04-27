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
      prefix = "sy",
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
    vim.keymap.set("n", "sc", "syykgccj", { remap = true, desc = "Duplicate Line and Comment" })
    vim.keymap.set("v", "sc", "sygvgcj", { remap = true, desc = "Duplicate Lines and Comment" })

    vim.keymap.set("n", "<M-d>", "sy", { remap = true, desc = "Duplicate Line" })
    vim.keymap.set("n", "<M-d><M-d>", "syy", { remap = true, desc = "Duplicate Line" })
    vim.keymap.set("v", "<M-d>", "sy", { remap = true, desc = "Duplicate Lines" })

    WhichKey.register({
      ["ssp="] = { desc = "Evaluate Math Expression (Operator)" },
      ["se"] = { desc = "Exchange Text (Operator)" },
      ["sy"] = { desc = "Duplicate Text (Operator)" },
      ["ss"] = { desc = "Sort Text (Operator)" },
    })
  end,
}
