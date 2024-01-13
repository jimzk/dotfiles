local disabled_nodes = {
  -- "call_expression",
}
return {
  -- Shows virtual text of the current context after functions, methods, statements, etc.
  "andersevenrud/nvim_context_vt",
  event = "VeryLazy",
  enabled = true,
  opts = {
    prefix = "<",
    min_rows = 5,
    highlight = "LspInlayHint",
    -- Rustaceanvim has its inlay hints. A bit annoying if there are more.
    disable_ft = { "markdown", "rust", "python" },
    -- default parser: https://github.com/andersevenrud/nvim_context_vt/blob/master/lua/nvim_context_vt/utils.lua#L25
    custom_parser = function(node, ft, opts)
      if vim.tbl_contains(disabled_nodes, node:type()) then
        return nil -- no display virtual text
      end
      local utils = require("nvim_context_vt.utils")
      local text = opts.prefix .. " " .. utils.get_node_text(node)[1]
      -- Remove trailing whitespace, [, {, (, |
      text = text:gsub("[%s%(%[{|=]+$", "")
      return text
    end,
  },
}
