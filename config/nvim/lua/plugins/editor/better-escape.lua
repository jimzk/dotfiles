-- NOTE: experimental
return {
  "max397574/better-escape.nvim",
  event = "InsertEnter",
  enabled = false,
  opts = {
    mapping = { "jj", "jk" }, -- a table with mappings to use
  },
}
