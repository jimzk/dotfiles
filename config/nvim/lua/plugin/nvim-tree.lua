


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

  { key = "zC",                              action = "collapse_all" },
  { key = "zO",                              action = "expand_all" },

  -- navigation in dir
  { key = { "<C-o>", "<2-RightMouse>" },    action = "cd" },
  { key = "u",                           action = "close_node" },
  { key = "<C-u>",                          action = "dir_up" },
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
  -- open_on_setup = true,         -- open nvim-tree when starting vim with directory
  -- open_on_setup_file = true,    -- open nvim-tree when starting vim with file
  sync_root_with_cwd = true,    -- sync nvim-tree when changing buffer's cwd
  respect_buf_cwd = true,       -- change nvim-tree cwd to buffer's cwd
  -- reload_on_bufenter = true,    -- sync nvim-tree when editing a new file
  view = {
    adaptive_size = true,
    width = 35,
    side = "right",
    mappings = {
      list = keymap,
    },
    float = {
      enable = false,
      open_win_config = {
        width = 35,
        height = 100,
      }
    },
  },
  renderer = {
    group_empty = true,  -- compact directory that only has one directory
    add_trailing = true,
    highlight_opened_files = "name",  -- highlight group NvimTreeOpenedFile
    indent_width = 1,
    symlink_destination = false,  -- not show symlink destination
  },
  filters = {
    dotfiles = false,  -- show hidden files
  },
  update_focused_file = {
    enable = true,  -- update item of focused file immediately in nvim-tree
  },
})

vim.cmd("autocmd ColorScheme * hi NvimTreeOpenedFile gui=underline")
vim.cmd("autocmd ColorScheme * hi NvimTreeSymlink guifg=gray")
