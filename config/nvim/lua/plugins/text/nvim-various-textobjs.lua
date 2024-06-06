local M = {
  "chrisgrieser/nvim-various-textobjs",
  event = "VeryLazy",
}

M.opts = {
  useDefaultKeymaps = false,
}

-- stylua: ignore
M.config = function(_, opts)
  local t = require("various-textobjs")
  t.setup(opts)
  local map = Util.map
  local ox = { "o", "x" }
  -- map(ox, "id", t.diagnostic, "Diagnostic")
  -- map(ox, "ad", t.diagnostic, "Diagnostic")
  map(ox, "|", t.column, "Column")
  -- Next
  -- map(ox, "}", function() t.restOfParagraph() end)
  -- map(ox, "a`", function() t.toNextClosingBracket() end, "To Next } ) ]")
  -- map(ox, "'", function() t.toNextQuotationMark() end, "To Next ' \" `")
  -- URL
  map(ox, "iu", t.url, "URL")
  map(ox, "au", t.url, "URL")
  -- Indentation
  -- map(ox, "ii", function() t.indentation("inner", "inner") end, "indent")
  -- map(ox, "ai", function() t.indentation("outer", "outer") end, "indent")
  map(ox, "iI", function() t.restOfIndentation() end, "To Indent End")
  map(ox, "aI", function() t.restOfIndentation() end, "To Indent End")
  -- Subword
  map(ox, "as", function() t.subword("outer") end, "Subword")
  map(ox, "is", function() t.subword("inner") end, "Subword")
  -- map(ox, "aS", "as", "sentence")
  -- map(ox, "iS", "is", "sentence")
  -- current lines. Outer include indent
  map(ox, "il", function() t.lineCharacterwise("inner") end, "Line")
  map(ox, "al", function() t.lineCharacterwise("outer") end, "Line")
  -- End of line
  -- map(ox, "L", function() t.nearEoL() end, "To Line End")
  -- chain member
  map(ox, "i.", function() t.chainMember("inner") end, "Chain Member")
  map(ox, "a.", function() t.chainMember("outer") end, "Chain Member")
  -- Key/value
  map(ox, "ik", function() t.key("inner") end, "Key (KV)")
  map(ox, "ak", function() t.key("outer") end, "Key (KV)")
  map(ox, "iv", function() t.value("inner") end, "Value (KV)")
  map(ox, "av", function() t.value("outer") end, "Value (KV)")
  -- Entire content
  map(ox, "iE", function() t.entireBuffer() end, "Entire Content")
  map(ox, "aE", function() t.entireBuffer() end, "Entire Content")
  map(ox, "ae", function() t.visibleInWindow() end, "Visible Content")
  map(ox, "ie", function() t.visibleInWindow() end, "Visible Content")

  -- Number
  map(ox, "id", function() t.number("inner") end, "Digits")
  map(ox, "ad", function() t.number("outer") end, "Digits")
  -- CSS
  map(ox, "i#", function() t.cssColor("inner") end, "Hex Color")
  map(ox, "a#", function() t.cssColor("outer") end, "Hex Color")

  -- Markdown
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown" },
    callback = function()
      local callback_opts = { buffer = true }
      map(ox, "iL", function() t.mdlink("inner") end, "Markdown Link", callback_opts)
      map(ox, "aL", function() t.mdlink("outer") end, "Markdown Link", callback_opts)
      map(ox, "iC", function() t.mdFencedCodeBlock("inner") end, "Markdown Code Block", callback_opts)
      map(ox, "aC", function() t.mdFencedCodeBlock("outer") end, "Markdown Code Block", callback_opts)
    end,
  })
end

return M
