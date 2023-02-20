local M = {
  "chrisgrieser/nvim-various-textobjs",
  event = "VeryLazy",
}

M.opts = {
  lookForwardLines = 50,
  useDefaultKeymaps = false
}

M.config = function(_, opts)
  local t = require("various-textobjs")
  t.setup(opts)

  local ox = { "o", "x" }
  -- diagnostic
  map(ox, "ix", t.diagnostic, "diagnostic")
  -- url
  map(ox, "ir", t.url, "url")
  -- Indentation
  map(ox, "iI", function() t.indentation(true, true) end, "indent in current context")
  map(ox, "aI", function() t.indentation(false, false) end, "indent in current context")
  map(ox, "i<C-i>", function() t.restOfIndentation() end, "to indent end")
  -- Paragraph
  -- map(ox, "<C-}>", function() t.restOfParagraph() end, "to paragraph end (linewise)")
  -- Key/value
  map(ox, "iv", function() t.value(true) end, "value (KV)")
  map(ox, "av", function() t.value(false) end, "value (KV)")
  map(ox, "ik", function() t.key(true) end, "key (KV)")
  map(ox, "ak", function() t.key(false) end, "key (KV)")
  -- entire content
  map(ox, "ie", function() t.entireBuffer() end, "entire content")
  map(ox, "ae", function() t.entireBuffer() end, "entire content")
  -- column down
  map(ox, "i|", function() t.column() end, "column down")
  -- Markdown
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown" },
    callback = function()
      local o = { buffer = true }
      map(ox, "iU", function() t.mdlink(true) end, "markdown link", o)
      map(ox, "aU", function() t.mdlink(false) end, "markdown link", o)
      map(ox, "iC", function() t.mdFencedCodeBlock(true) end, "markdown code block", o)
      map(ox, "aC", function() t.mdFencedCodeBlock(false) end, "markdown code block", o)
    end,
  })
end

return M
