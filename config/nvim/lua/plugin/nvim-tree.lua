-- disable vim's builtin plugin for file explorer
-- NOTE: rust-tools open_external_docs can't work if netrw is disabled
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-- default mapping: :h nvim-tree-default-mappings
local mappings = {
  -- help
  ["toggle_help"] = { "g?", "\\" },
  ["toggle_file_info"] = "i",
  ["run_file_command"] = "<C-r>",

  -- open file
  ["edit"] = { "<Cr>", "<2-LeftMouse>" },
  ["edit_in_place"] = "e",
  ["edit_no_picker"] = "E",
  ["vsplit"] = "v",
  ["split"] = "s",
  ["tabnew"] = "t",
  ["preview"] = "o",

  -- navigation in file
  ["prev_sibling"] = "u",
  ["next_sibling"] = "d",
  ["first_sibling"] = "K",
  ["last_sibling"] = "J",
  ["parent_node"] = "_",

  ["prev_diag_item"] = "[x", -- diagnostic item
  ["next_diag_item"] = "]x",
  ["prev_git_item"] = "h",
  ["next_git_item"] = "l",
  ["collapse_all"] = "H",
  ["expand_all"] = "L",

  -- navigation in dir
  ["cd"] = { "<C-o>", "<2-RightMouse>" },
  ["close_node"] = "-",
  ["dir_up"] = "<C-i>",
  ["close"] = "q",

  -- search
  ["live_filter"] = "f",
  ["clear_live_filter"] = "F",
  ["search_node"] = "<C-f>",

  -- file operations
  ["create"] = "n",
  -- ["remove" ] = "<BS>",
  ["trash"] = "<BS>",
  ["cut"] = "x",
  ["copy"] = "y",
  ["paste"] = "p",
  ["rename"] = "r",
  ["full_rename"] = "R",
  ["copy_name"] = "a",
  ["copy_path"] = "A",
  ["copy_absolute_path"] = "<C-a>",
  ["system_open"] = "<C-e>",
  ["bulk_move"] = "m",

  -- settings
  ["toggle_mark"] = "<M-m>",
  ["toggle_git_ignored"] = "<M-g>",
  ["toggle_dotfiles"] = "<M-d>",
  ["toggle_custom"] = "<M-c>",
  ["refresh"] = "<M-r>",
}

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  -- open_on_setup = true,         -- open nvim-tree when starting vim with directory
  -- open_on_setup_file = true,    -- open nvim-tree when starting vim with file
  sync_root_with_cwd = true, -- sync nvim-tree when changing buffer's cwd
  respect_buf_cwd = true, -- change nvim-tree cwd to buffer's cwd
  -- reload_on_bufenter = true,    -- sync nvim-tree when editing a new file
  view = {
    adaptive_size = true,
    width = 35,
    side = "left",
    mappings = {
      custom_only = true,
      list = (function()
        local list = {}
        for action, key in pairs(mappings) do
          table.insert(list, { key = key, action = action })
        end
        return list
      end)(),
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
    group_empty = true, -- compact directory that only has one directory
    add_trailing = true,
    highlight_opened_files = "name", -- highlight group NvimTreeOpenedFile
    indent_width = 1,
    symlink_destination = false, -- not show symlink destination
  },
  filters = {
    dotfiles = false, -- show hidden files
  },
  update_focused_file = {
    enable = true, -- update item of focused file immediately in nvim-tree
  },
  notify = {
    threshold = vim.log.levels.WARN,
  },
  trash = {
    cmd = "trash",
    require_confirm = false,
  },
})

vim.cmd("autocmd ColorScheme * hi NvimTreeOpenedFile gui=underline")
vim.cmd("autocmd ColorScheme * hi NvimTreeSymlink guifg=gray")
