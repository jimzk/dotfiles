return {
  "echasnovski/mini.operators",
  event = "BufReadPost",
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
    vim.keymap.set("n", "sYY", "syykgccj", { remap = true, desc = "Duplicate Line and Comment" })
    vim.keymap.set("v", "sY", "sygvgcj", { remap = true, desc = "Duplicate Lines and Comment" })

    require("which-key").register({
      ["ssp="] = { desc = "Evaluate Math Expression (Operator)" },
      ["se"] = { desc = "Exchange Text (Operator)" },
      ["sy"] = { desc = "Duplicate Text (Operator)" },
      ["sY"] = { desc = "Duplicate Text and Comment (Operator)" },
      ["ss"] = { desc = "Sort Text (Operator)" },
      -- ["sy"] = { desc = "Replace Text with Register" },
    })
  end,
}
