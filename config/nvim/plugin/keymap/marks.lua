
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

-- register cheatsheet
require("which-key").register({
  m = {
    name = "mark",
    ["1"] = {"set mark 1"},
    ["a"] = {"set mark a"},
    ["A"] = {"set mark A (across buffers)"},
    [";"] = {"preview mark (then press a or <cr>)"},
    ["]"] = {"move to next mark"},
    ["["] = {"move to previous mark"},
    ["-"] = {"delete current marks"},
  }
}, {prefix = [[<leader>\\]]})
