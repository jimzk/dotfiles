local specs = require("util").load_specs("text")

vim.list_extend(specs, {
  -- makes some plugins dot-repeatable like leap
  { "tpope/vim-repeat", event = "VeryLazy" },
})
return specs
