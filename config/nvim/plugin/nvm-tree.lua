


-- examples for your init.lua

-- disable vim's builtin plugin for file explorer
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- keymap: https://github.com/nvim-tree/nvim-tree.lua/blob/master/doc/nvim-tree-lua.txt#L1303
local keymap = {
  -- clean default keymap
  { key = { "<CR>", "o", "<2-LeftMouse>" }, action = "" },
  { key = "<C-e>",                          action = "" },
  { key = "O",                              action = "" },
  { key = { "<C-]>", "<2-RightMouse>" },    action = "" },
  { key = "<C-v>",                          action = "" },
  { key = "<C-x>",                          action = "" },
  { key = "<C-t>",                          action = "" },
  { key = "<",                              action = "" },
  { key = ">",                              action = "" },
  { key = "P",                              action = "" },
  { key = "<BS>",                           action = "" },
  { key = "<Tab>",                          action = "" },
  { key = "K",                              action = "" },
  { key = "J",                              action = "" },
  { key = "I",                              action = "" },
  { key = "H",                              action = "" },
  { key = "U",                              action = "" },
  { key = "R",                              action = "" },
  { key = "a",                              action = "" },
  { key = "d",                              action = "" },
  { key = "D",                              action = "" },
  { key = "r",                              action = "" },
  { key = "<C-r>",                          action = "" },
  { key = "x",                              action = "" },
  { key = "c",                              action = "" },
  { key = "p",                              action = "" },
  { key = "y",                              action = "" },
  { key = "Y",                              action = "" },
  { key = "gy",                             action = "" },
  { key = "[e",                             action = "" },
  { key = "[c",                             action = "" },
  { key = "]e",                             action = "" },
  { key = "]c",                             action = "" },
  { key = "-",                              action = "" },
  { key = "s",                              action = "" },
  { key = "f",                              action = "" },
  { key = "F",                              action = "" },
  { key = "q",                              action = "" },
  { key = "W",                              action = "" },
  { key = "E",                              action = "" },
  { key = "S",                              action = "" },
  { key = ".",                              action = "" },
  { key = "<C-k>",                          action = "" },
  { key = "g?",                             action = "" },
  { key = "m",                              action = "" },
  { key = "bmv",                            action = "" },

  -- help
  { key = {"g?", "\\"},                     action = "toggle_help" },
  { key = "i",                              action = "toggle_file_info" },
  { key = "m",                              action = "toggle_mark" },
  { key = ".",                              action = "run_file_command" },

  -- open file
  { key = { "<CR>", "o", "<2-LeftMouse>" }, action = "edit" },
  { key = "e",                              action = "edit_in_place" },
  { key = "O",                              action = "edit_no_picker" },
  { key = "v",                              action = "vsplit" },
  { key = "s",                              action = "split" },
  { key = "t",                              action = "tabnew" },
  { key = "p",                              action = "preview" },

  -- navigation in file
  { key = "K",                              action = "prev_sibling" },
  { key = "J",                              action = "next_sibling" },
  { key = "H",                              action = "first_sibling" },
  { key = "L",                              action = "last_sibling" },
  { key = "n",                              action = "parent_node" },

  { key = "[e",                             action = "prev_diag_item" },
  { key = "]e",                             action = "next_diag_item" },
  { key = "[c",                             action = "prev_git_item" },
  { key = "]c",                             action = "next_git_item" },

  { key = ";",                              action = "collapse_all" },
  { key = "'",                              action = "expand_all" },

  -- navigation in dir
  { key = { "<C-o>", "<2-RightMouse>" },    action = "cd" },
  { key = "<BS>",                           action = "close_node" },
  { key = "<C-i>",                          action = "dir_up" },
  { key = "q",                              action = "close" },

  -- search
  { key = "f",                              action = "live_filter" },
  { key = "F",                              action = "clear_live_filter" },
  { key = "a",                              action = "search_node" },

  -- file operations
  { key = "<C-n>",                          action = "create" },
  { key = "<C-d>",                          action = "remove" },
  { key = "<C-.>",                          action = "trash" },
  { key = "<C-x>",                          action = "cut" },
  { key = "<C-c>",                          action = "copy" },
  { key = "<C-v>",                          action = "paste" },
  { key = "<C-r>",                          action = "rename" },
  { key = "<C-t>",                          action = "full_rename" },
  { key = "<C-m>",                          action = "copy_name" },
  { key = "<C-p>",                          action = "copy_path" },
  { key = "<C-a>",                          action = "copy_absolute_path" },
  { key = "<C-e>",                          action = "system_open" },
  { key = "<C-b>",                          action = "bulk_move" },

  -- settings
  { key = "<M-g>",                          action = "toggle_git_ignored" },
  { key = "<M-d>",                          action = "toggle_dotfiles" },
  { key = "<M-u>",                          action = "toggle_custom" },
  { key = "<M-r>",                          action = "refresh" },
}

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      list = keymap,
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
