local M = {}

M.load_specs = function(dir, specs)
  local path = vim.fn.stdpath("config") .. "/lua/plugins/" .. dir
  local paths = vim.split(vim.fn.glob(path .. "/*"), "\n")
  specs = specs or {}
  for _, file in pairs(paths) do
    local basename = vim.fs.basename(file):gsub("%.lua", "")
    -- Ignore init.lua and _* file
    if basename ~= "init" and basename:sub(1, 1) ~= "_" then
      local package = "plugins." .. dir .. "." .. basename
      table.insert(specs, require(package))
    end
  end
  return specs
end

M.tbl_combine = function(left, right)
  for _, value in ipairs(right) do
    table.insert(left, value)
  end
  return left
end

local unlisted_ft = {
  "notify",
  "fidget",
}

local get_wins = function(tabnr)
  tabnr = tabnr or 0
  local winnrs = {}
  for _, winnr in ipairs(vim.api.nvim_tabpage_list_wins(tabnr)) do
    local bufnr = vim.fn.winbufnr(winnr)
    local ft = vim.bo[bufnr].ft
    if not vim.tbl_contains(unlisted_ft, ft) then
      table.insert(winnrs, winnr)
    end
  end
  return winnrs
end

M.map = function(mode, lhs, rhs, desc, opts)
  opts = opts or {}
  if rhs == nil then
    opts.mode = mode
    vim.defer_fn(function()
      require("which-key").register({ [lhs] = { desc or "which_key_ignore" } }, opts)
    end, 1000)
    return
  end
  if desc == nil then
    desc = "which_key_ignore"
  elseif desc == "" then
    desc = nil
  end
  opts.desc = desc
  opts.silent = true
  opts.mode = nil
  vim.keymap.set(mode, lhs, rhs, opts)
end

M.feedkeys = function(key_codes, mode)
  return function()
    key_codes = vim.api.nvim_replace_termcodes(key_codes, true, false, true)
    mode = mode or "m"
    vim.api.nvim_feedkeys(key_codes, mode, false)
  end
end

-- https://www.reddit.com/r/neovim/comments/1abd2cq/comment/kjq03xa
-- M.get_selected = function()
--   local _, ls, cs = table.unpack(vim.fn.getpos("v"))
--   local _, le, ce = table.unpack(vim.fn.getpos("."))
--   local selected = vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
--   return table.concat(selected)
-- end

M.get_selected = function()
  local cmd = vim.fn.mode() == "n" and [["vyiw']] or [["vy']]
  vim.cmd("normal! " .. cmd)
  return vim.fn.getreg("v")
end

-- Wrap make_repeatable_move_pair
-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects#text-objects-move
-- local keys = vim.api.nvim_replace_termcodes("zz", true, false, true)
M.make_repeatable_move_pair = function(forward_move_fn, backward_move_fn)
  if vim.g.vscode then
    return forward_move_fn, backward_move_fn
  end
  local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
  local forward_move_fn_proxy = function(...)
    forward_move_fn(...)
    -- vim.api.nvim_feedkeys(keys, "m", true)
  end
  local backward_move_fn_proxy = function(...)
    backward_move_fn(...)
    -- vim.api.nvim_feedkeys(keys, "m", true)
  end
  return ts_repeat_move.make_repeatable_move_pair(forward_move_fn_proxy, backward_move_fn_proxy)
end

M.map_repeatable_move = function(mode, key, fn, desc, opts)
  local forward, backward = M.make_repeatable_move_pair(fn[1], fn[2])
  M.map(mode, key[1], forward, desc and desc[1], opts)
  M.map(mode, key[2], backward, desc and desc[2], opts)
end

M.toggle = function(enabled, fn, desc, title)
  local enable_fn, disable_fn = function() end, function() end
  if type(fn) == "function" then
    enable_fn, disable_fn = fn, fn
  elseif type(fn) == "table" then
    enable_fn, disable_fn = fn[1], fn[2]
  end
  title = title and title or "Option"
  local opts = { title = title }
  local level
  if type(enabled) == "function" then
    enabled = enabled()
  end
  if enabled then
    disable_fn()
    level = vim.log.levels.WARN
    desc = "Disable " .. desc
  else
    enable_fn()
    level = vim.log.levels.INFO
    desc = "Enable " .. desc
  end
  require("notify").dismiss({ silent = true, pending = false })
  require("notify")(desc, level, opts)
end

_G.copy = function(...)
  local msg = "empty params"
  local params = {}
  if next({ ... }) then
    -- get the count of the params
    for i = 1, select("#", ...) do
      -- select the param
      local param = select(i, ...)
      table.insert(params, vim.inspect(param))
    end
  else
  end
  if #params > 0 then
    msg = table.concat(params, "\n")
  end
  vim.fn.setreg("+", msg)
  return msg
end

_G.info = function(msg)
  vim.notify(msg, vim.log.levels.INFO, { title = "DEBUG" })
end

_G.Util = M

_G.WhichKey = {}

_G.WhichKey.register = function(mappings, opts)
  local ok, which_key = pcall(require, "which-key")
  if ok then
    which_key.register(mappings, opts)
  end
end

return M
