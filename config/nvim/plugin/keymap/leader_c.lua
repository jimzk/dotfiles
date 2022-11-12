local builtin = require("telescope.builtin")

local leader_c = {
  name = "coding",
  s = {function() builtin.treesitter({
      prompt_title = "Function Names, Variables and Symbols",
      results_title = "autocompletion menu ^l",
    }) end, "symbol in current buffer"},
  q = {function() builtin.quickfix({
      prompt_title = "Quick Fix",
    }) end, "list items in quickfix"},
  ["/"] = {function() builtin.search_history({
      prompt_title = "Search History",
    }) end, "list search history"},
  m = {function() builtin.filetypes({
      prompt_title = "Change Filetype",
    }) end, "change current buffer's filetype"},
}
require("which-key").register(leader_c, {prefix = "<leader>c"})
