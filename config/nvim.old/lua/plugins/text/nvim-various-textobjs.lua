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
  local o = { "o" }
  map(ox, "!", t.diagnostic, "diagnostic")
  map(ox, "i<TAB>", function() t.column() end, "column")
  map(ox, "a<TAB>", function() t.column() end, "column")
  map(ox, "iu", t.url, "url")
  map(ox, "au", t.url, "url")
  -- Indentation
  -- map(ox, "ii", function() t.indentation("inner", "inner") end, "indent")
  -- map(ox, "ai", function() t.indentation("outer", "outer") end, "indent")
  map(ox, "iI", function() t.restOfIndentation() end, "to indent end")
  map(ox, "aI", function() t.restOfIndentation() end, "to indent end")
  -- Next
  map(ox, "}", function() t.restOfParagraph() end)
  map(ox, "C", function() t.toNextClosingBracket() end, "to next } ) ]")
  map(ox, "Q", function() t.toNextQuotationMark() end, "to next ' \" `")
  -- Subword
  map(ox, "as", function() t.subword("outer") end)
  map(ox, "is", function() t.subword("inner") end)
  map(ox, "aS", "as", "sentence")
  map(ox, "iS", "is", "sentence")
  -- current line
  map(ox, "il", function() t.lineCharacterwise("inner") end, "line")
  map(ox, "al", function() t.lineCharacterwise("outer") end, "line")
  map(ox, "iL", function() t.nearEoL() end, "end of line")
  map(ox, "aL", function() t.nearEoL() end, "end of line")
  -- chain member
  map(ox, "iM", function() t.chainMember("inner") end, "chain member")
  map(ox, "aM", function() t.chainMember("outer") end, "chain member")
  -- Key/value
  map(ox, "iK", function() t.key("inner") end, "key (KV)")
  map(ox, "aK", function() t.key("outer") end, "key (KV)")
  map(ox, "iV", function() t.value("inner") end, "value (KV)")
  map(ox, "aV", function() t.value("outer") end, "value (KV)")
  -- Entire content
  map(ox, "ie", function() t.entireBuffer() end, "entire content")
  map(ox, "ae", function() t.entireBuffer() end, "entire content")
  map(ox, "a<cr>", function() t.visibleInWindow() end, "entire visible content")
  map(ox, "i<cr>", function() t.visibleInWindow() end, "entire visible content")
  -- Markdown
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown" },
    callback = function()
      local o = { buffer = true }
      map(ox, "iL", function() t.mdlink("inner") end, "markdown link", o)
      map(ox, "aL", function() t.mdlink("outer") end, "markdown link", o)
      map(ox, "iC", function() t.mdFencedCodeBlock("inner") end, "markdown code block", o)
      map(ox, "aC", function() t.mdFencedCodeBlock("outer") end, "markdown code block", o)
    end,
  })
end

return M
