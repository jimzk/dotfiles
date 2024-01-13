-- For debug
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

_G.dbg = function(msg)
  vim.notify(msg, vim.log.levels.INFO, { title = "DEBUG" })
end

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
