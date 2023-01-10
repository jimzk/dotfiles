-- disable vim's builtin plugin for file explorer
-- NOTE: rust-tools open_external_docs can't work if netrw is disabled
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

local api = require("nvim-tree.api")
local notify_opts = { title = "Nvim Tree" }
-- default mapping: :h nvim-tree-default-mappings
local mappings = {
  -- help
  ["?"] = "toggle_help",
  ["i"] = "toggle_file_info",
  ["\\"] = "run_file_command",

  -- open file
  ["<2-LeftMouse>"] = "edit",
  ["<Cr>"] = "edit",
  -- ["e"] = "edit_in_place",
  -- ["E"] = "edit_no_picker",
  ["v"] = "vsplit",
  ["s"] = "split",
  -- ["t"] = "tabnew",
  ["l"] = "preview",
  ["h"] = "close_node",

  -- navigation in file
  ["K"] = "prev_sibling",
  ["J"] = "next_sibling",
  ["H"] = "first_sibling",
  ["L"] = "last_sibling",
  ["_"] = "parent_node",

  ["[x"] = "prev_diag_item", -- diagnostic item
  ["]x"] = "next_diag_item",
  ["[g"] = "prev_git_item",
  ["]g"] = "next_git_item",
  ["zM"] = "collapse_all",
  ["zR"] = "expand_all",

  -- navigation in dir
  ["<2-RightMouse>"] = "cd",
  ["="] = "cd",
  ["-"] = "dir_up",
  ["q"] = "close",

  -- search
  ["f"] = "live_filter",
  ["F"] = "clear_live_filter",
  ["<M-f>"] = "search_node",

  -- file operations
  ["<C-n>"] = "create",
  -- ["remove" ] = "<BS>",
  ["<BS>"] = "trash",
  ["<C-x>"] = "cut",
  ["<C-c>"] = "copy",
  ["<C-v>"] = "paste",
  ["<C-r>"] = "rename_basename",
  ["<C-s-r>"] = "rename",
  ["<C-a-r>"] = "full_rename",
  ["<C-y>"] = "copy_name",
  ["<C-s-y>"] = "copy_path",
  ["<C-a-y>"] = "copy_absolute_path",
  ["<C-e>"] = "system_open",
  ["<C-m>"] = "bulk_move",

  -- settings
  ["m"] = "toggle_mark",
  ["<M-g>"] = "toggle_git_ignored",
  ["<M-d>"] = "toggle_dotfiles",
  ["<M-c>"] = "toggle_custom",
  ["<M-r>"] = "refresh",

  ["g"] = { function()
    local ok, file_path = pcall(vim.api.nvim_buf_get_name, vim.g.last_accessed_buf)
    if ok then
      api.tree.find_file(file_path)
    else
      vim.notify("Can't focus file", vim.log.levels.ERROR, notify_opts)
    end
  end, "focus on file" }
}

local list = {}
for key, value in pairs(mappings) do
  if type(value) == "string" then
    table.insert(list, { key = key, action = value })
  elseif type(value) == "table" then
    table.insert(list, { key = key, action = value[2], action_cb = value[1] })
  else
    vim.notify("Unrecognized type", vim.log.levels.ERROR, notify_opts)
  end
end

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  open_on_setup = false, -- open nvim-tree when starting vim with directory
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
      list = list,
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
    enable = false, -- focus item after opening a buffer
    ignore_list = {}
  },
  notify = {
    threshold = vim.log.levels.WARN,
  },
  trash = {
    cmd = "trash",
    require_confirm = false,
  },
  hijack_cursor = true, -- Fix cursor in nvim-tree
  tab = {
    sync = { -- sync nvim-tree cross table
      open = true,
      close = true,
    }
  }
})

-- vim.cmd("autocmd ColorScheme * hi NvimTreeOpenedFile gui=underline")
vim.cmd("autocmd ColorScheme * hi NvimTreeSymlink guifg=gray")
set("n", "<leader>n", function()
  if vim.bo.filetype == "NvimTree" then
    vim.cmd [[wincmd p]]
  end
  vim.cmd [[NvimTreeFindFile]]
end)

set("n", "<leader>N", "<cmd>NvimTreeToggle<cr>")

-- set("n", "<M-esc>", function()
--   if vim.bo.filetype == "NvimTree" then
--     vim.cmd [[wincmd p]]
--   end
--   vim.cmd [[NvimTreeFindFile]]
-- end)

-- set("n", "<M-1>", "<cmd>NvimTreeToggle<cr>")
