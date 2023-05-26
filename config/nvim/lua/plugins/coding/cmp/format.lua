local M = {}

M.icons = {
  Array = " ",
  Boolean = " ",
  Class = " ",
  Color = " ",
  Constant = " ",
  Constructor = " ",
  Copilot = " ",
  Cmd = "⌘ ",
  Enum = " ",
  EnumMember = " ",
  Event = " ",
  Field = " ",
  File = " ",
  Folder = " ",
  Function = " ",
  Interface = " ",
  Key = " ",
  Keyword = " ",
  Method = " ",
  Module = " ",
  Namespace = " ",
  Null = "ﳠ ",
  Number = " ",
  Object = " ",
  Operator = " ",
  Package = " ",
  Property = " ",
  Reference = " ",
  Snippet = " ",
  String = " ",
  Struct = " ",
  Text = " ",
  TypeParameter = " ",
  Unit = " ",
  Value = " ",
  Variable = " ",
}

M.menu = {
  buffer = "[Buffer]",
  cmdline = "[Cmd]",
  nvim_lsp = "[LSP]",
  luasnip = "[LuaSnip]",
  calc = "[Calc]",
  path = "[Path]",
}

M.maxwidth = 45

M.format = function(entry, item)
  item.kind = (M.icons[item.kind] or "") .. item.kind
  if #item.abbr > M.maxwidth then
    local maxwidth = M.maxwidth
    if vim.o.filetype == "rust" then
      maxwidth = maxwidth + 20
    end
    item.abbr = vim.fn.strcharpart(item.abbr, 0, maxwidth) .. "…"
  end
  item.menu = M.menu[entry.source.name]
  return item
end

M.format_cmdline = function(entry, item)
  if entry.source.name == "cmdline" then
    item.kind = "Cmd"
  end
  item.kind = (M.icons[item.kind] or "") .. item.kind
  return item
end

return M
