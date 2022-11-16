
-- marks.nvim
require("which-key").register({
  d = {
    m = {
      name = "delete bookmark",
      ["1"] = "delete mark 1",
      ["a"] = "delete mark a",
      ["A"] = "delete mark A",
      ["<space>"] = "delete marks in cursor line",
      ["-"] = "delete all marks in current buffer",
    },
  },
})

vim.keymap.set("n", "m-", "<cmd>lua require'marks'.delete_line()<cr>")
