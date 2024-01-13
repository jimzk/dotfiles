local M = {}

M.menu = {
  buffer = "[Buffer]",
  cmdline = "[Cmd]",
  nvim_lsp = "[LSP]",
  luasnip = "[LuaSnip]",
  calc = "[Calc]",
  path = "[Path]",
  copilot = "[Copilot]",
}

M.maxwidth = 45
M.format = function(entry, item)
  local icons = require("lazyvim.config").icons.kinds
  if icons[item.kind] then
    item.kind = icons[item.kind] .. item.kind
  end
  item.menu = M.menu[entry.source.name] or "???"
  local ft = entry.context.filetype
  if #item.abbr > M.maxwidth then
    local maxwidth = M.maxwidth
    if ft == "rust" then
      maxwidth = maxwidth + 20
    end
    item.abbr = vim.fn.strcharpart(item.abbr, 0, maxwidth) .. "…"
  end
  return item
end

M.format_cmdline = function(entry, item)
  local icons = require("lazyvim.config").icons.kinds
  if icons[item.kind] then
    item.kind = icons[item.kind] .. item.kind
  end
  if entry.source.name == "cmdline" then
    item.kind = "Cmd"
  end
  return item
end

return M
