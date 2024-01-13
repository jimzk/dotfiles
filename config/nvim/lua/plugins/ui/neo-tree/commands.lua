local utils = require("neo-tree.utils")
local cmds = require("neo-tree.sources.filesystem.commands")
local inputs = require("neo-tree.ui.inputs")
local filesystem = require("neo-tree.sources.filesystem")
local renderer = require("neo-tree.ui.renderer")

local close_tree_in_buf = function()
  local path = vim.api.nvim_buf_get_name(0)
  local in_neo_tree = string.find(path, "neo%-tree filesystem")
  if not in_neo_tree then
    vim.cmd("Neotree close")
  end
end

local M = {
  { "toggle_preview", config = { use_float = true } },
}

M.split_with_window_picker_and_close = function(state)
  state.commands["split_with_window_picker"](state)
  close_tree_in_buf()
end
M.vsplit_with_window_picker_and_close = function(state)
  state.commands["vsplit_with_window_picker"](state)
  close_tree_in_buf()
end
M.open_with_window_picker_and_close = function(state)
  -- copy(state.commands)  -- List all available commands
  state.commands["open_with_window_picker"](state)
  close_tree_in_buf()
end
M.open_drop_and_close = function(state)
  -- copy(state.commands)  -- List all available commands
  state.commands["open_drop"](state)
  close_tree_in_buf()
end

M.open_with_vscode = function(state)
  local node = state.tree:get_node()
  local path = node:get_id()
  vim.fn.jobstart({ "code", path }, { detach = true })
end
-- https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Tips#open-file-without-losing-sidebar-focus
M.open_without_focus = function(state)
  local node = state.tree:get_node()
  if utils.is_expandable(node) then
    state.commands["toggle_node"](state)
  else
    state.commands["open"](state)
    vim.cmd("Neotree reveal")
  end
end
M.open_or_focus = function(state)
  local node = state.tree:get_node()
  local node_path = node.path
  local win_ids = vim.api.nvim_list_wins()
  for _, win_id in pairs(win_ids) do
    local buf_id = vim.api.nvim_win_get_buf(win_id)
    local path = vim.api.nvim_buf_get_name(buf_id)
    if node_path == path then
      vim.api.nvim_set_current_win(win_id)
      vim.notify(path)
      return
    end
  end
end

M.view_filesystem = function()
  vim.cmd("Neotree focus filesystem left")
end
M.view_buffers = function()
  vim.cmd("Neotree focus buffers left")
end
M.view_git_status = function()
  vim.cmd("Neotree focus git_status left")
end
M.view_remote = function()
  vim.cmd("Neotree focus remote left")
end

-- If node is directory then set it to root, oherwise set parent to root
M.set_tree_root = function(state)
  local node = state.tree:get_node()
  if not (node.type == "directory") then
    local parent_id = node:get_parent_id()
    require("neo-tree.ui.renderer").focus_node(state, parent_id)
  end
  state.commands["set_root"](state)
end

M.close_node_or_go_parent = function(state) -- Go to parent or close node
  local node = state.tree:get_node()
  if node.type == "directory" and node:is_expanded() then
    filesystem.toggle_directory(state, node)
  else
    require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
  end
end

M.toggle_node_smart = function(state) -- Go to first child or open node
  local node = state.tree:get_node()
  if node.type ~= "directory" then
    local parent_id = node:get_parent_id()
    renderer.focus_node(state, parent_id)
  end
  state.commands["toggle_node"](state)
end

M.open_node_or_go_child = function(state) -- Go to first child or open node
  local node = state.tree:get_node()
  if node.type == "directory" then
    if not node:is_expanded() then
      filesystem.toggle_directory(state, node)
    elseif node:has_children() then
      require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
    end
  else
    -- -- open or focus
    -- local file_win_id = nil
    -- local node_path = node.path
    -- local win_ids = vim.api.nvim_list_wins()
    -- for _, win_id in pairs(win_ids) do
    --   local buf_id = vim.api.nvim_win_get_buf(win_id)
    --   local path = vim.api.nvim_buf_get_name(buf_id)
    --   if node_path == path then
    --     file_win_id = win_id
    --   end
    -- end
    -- if file_win_id then
    --   vim.api.nvim_set_current_win(file_win_id)
    -- else
    --   state.commands["open"](state)
    --   vim.cmd("Neotree reveal")
    -- end
  end
end

-- https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/220
M.go_first_sibling = function(state)
  local node = state.tree:get_node()
  local parent_id = node:get_parent_id()
  local siblings = state.tree:get_nodes(parent_id)
  renderer.focus_node(state, siblings[1]:get_id())
end
M.go_last_sibling = function(state)
  local node = state.tree:get_node()
  local parent_id = node:get_parent_id()
  local siblings = state.tree:get_nodes(parent_id)
  renderer.focus_node(state, siblings[#siblings]:get_id())
end

local go_sibling = function(state, node, direction)
  local current_node_id = node.id
  local parent_id = node:get_parent_id()
  local children = state.tree:get_nodes(parent_id)
  local idx = -1
  for i, child in ipairs(children) do
    if child.id == current_node_id then
      idx = i
      break
    end
  end
  if idx == -1 then
    return
  end
  idx = direction == "next" and idx + 1 or idx - 1
  if idx < 1 or idx > #children then
    return
  end
  renderer.focus_node(state, children[idx]:get_id())
end

M.prev_sibling = function(state)
  local node = state.tree:get_node()
  go_sibling(state, node, "prev")
end
M.next_sibling = function(state)
  local node = state.tree:get_node()
  go_sibling(state, node, "next")
end

M.go_parent = function(state)
  local node = state.tree:get_node()
  local parent_id = node:get_parent_id()
  renderer.focus_node(state, parent_id)
end

M.go_parent_sibling = function(state)
  local node = state.tree:get_node()
  local parent_node = state.tree:get_node(node:get_parent_id())
  go_sibling(state, parent_node, "next")
end

M.reveal_file = function()
  local win_id = require("window-picker").pick_window()
  if not win_id then
    return
  end
  local buf_id = vim.api.nvim_win_get_buf(win_id)
  local path = vim.api.nvim_buf_get_name(buf_id)
  if path == "" then
    vim.cmd("wincmd p")
  else
    vim.cmd("Neotree reveal_file=" .. path)
    return
  end
end

-- https://www.reddit.com/r/neovim/comments/187kdod/comment/kbi8xfl
M.spectre_replace = function(state)
  local opts = { is_close = false }
  local node = state.tree:get_node()
  if node.type == "directory" then
    opts.cwd = node.path
  else
    local path = node.path
    -- local parent = vim.fn.fnamemodify(path, ":h")
    local basename = vim.fn.fnamemodify(path, ":t")
    opts.path = basename
  end
  require("spectre").open(opts)
  vim.cmd("Neotree close")
end

-- https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Recipes#trash-macos
-- Trash the target
M.trash = function(state)
  local tree = state.tree
  local node = tree:get_node()
  if node.type == "message" then
    return
  end
  local _, name = utils.split_path(node.path)
  local msg = string.format("Are you sure you want to trash '%s'?", name)
  inputs.confirm(msg, function(confirmed)
    if not confirmed then
      return
    end
    vim.api.nvim_command("silent !trash -F " .. node.path)
    cmds.refresh(state)
  end)
end
-- https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Recipes#trash-macos
-- Trash the selections (visual mode)
M.trash_visual = function(state, selected_nodes)
  local paths_to_trash = {}
  for _, node in ipairs(selected_nodes) do
    if node.type ~= "message" then
      table.insert(paths_to_trash, node.path)
    end
  end
  local msg = "Are you sure you want to trash " .. #paths_to_trash .. " items?"
  inputs.confirm(msg, function(confirmed)
    if not confirmed then
      return
    end
    for _, path in ipairs(paths_to_trash) do
      vim.api.nvim_command("silent !trash -F " .. path)
    end
    cmds.refresh(state)
  end)
end

-- https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Recipes#find-with-telescope
M.telescope_grep = function(state)
  local node = state.tree:get_node()
  local path = node:get_id()
  require("telescope.builtin").live_grep({
    search_dirs = { path },
    prompt_title = "Live Grep in Buffer (" .. path:gsub("^" .. vim.env.HOME, "~") .. ")",
  })
end

M.copy_filename = function(state)
  local node = state.tree:get_node()
  local path = node:get_id()
  local filename = vim.fn.fnamemodify(path, ":t")
  -- Remove extension
  filename = vim.fn.fnamemodify(filename, ":r")
  vim.fn.setreg("+", filename)
  vim.notify("Filename " .. filename .. " copied")
end

return M
