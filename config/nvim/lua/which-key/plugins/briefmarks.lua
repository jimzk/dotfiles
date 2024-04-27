-- Make which-key marks cheatsheet more brief
-- Ref: https://www.reddit.com/r/neovim/comments/19aoa2y/i_extended_which_keyvim_to_make_it_more_useful/
local M = {}

--[[
~/.config/nvim/lua/which-key/plugins/briefmarks.lua
This extends which-key/plugins/marks.lua with these changes:
* Only show subset of marks
  * Letters
  * ^ . '
* Don't show duplicate marks
You must disable "marks" and enable "briefmarks" to use this.
--]]

local marks_module = require("which-key.plugins.marks")

M.name = "briefmarks"

M.actions = marks_module.actions

function M.setup(_wk, _config, options) end

M.allowed_marks = { "^", ".", "'" }

---@type Plugin
---@return PluginItem[]
function M.run(_trigger, _mode, buf)
  local marks = marks_module.run(_trigger, _mode, buf)

  local unique_values = {}
  for i = #marks, 1, -1 do
    local key = marks[i].key
    local value = marks[i].value

    if (key:match("^%a$") or vim.tbl_contains(M.allowed_marks, key)) and not unique_values[value] then
      -- mark is allowed, but don't let duplicates later
      unique_values[value] = true
    else
      -- Remove non-unique marks or unsupported marks
      table.remove(marks, i)
    end
  end

  return marks
end

return M
