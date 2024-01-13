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
  local map = require("util").map
  local ox = { "o", "x" }
  -- map(ox, "id", t.diagnostic, "Diagnostic")
  -- map(ox, "ad", t.diagnostic, "Diagnostic")
  map("n", "<C-\\>", function()
    vim.cmd("normal! v")
    t.column()
  end, "Visual Column")
  map(ox, "i<C-v>", function() t.column() end, "Column")
  map(ox, "iu", t.url, "URL")
  map(ox, "au", t.url, "URL")
  -- Indentation
  -- map(ox, "ii", function() t.indentation("inner", "inner") end, "indent")
  -- map(ox, "ai", function() t.indentation("outer", "outer") end, "indent")
  map(ox, "iI", function() t.restOfIndentation() end, "To Indent End")
  map(ox, "aI", function() t.restOfIndentation() end, "To Indent End")
  -- Next
  -- map(ox, "}", function() t.restOfParagraph() end)
  map(ox, "i<Tab>", function() t.toNextClosingBracket() end, "To Next } ) ]")
  -- map(ox, "i<Tab>", function() t.toNextQuotationMark() end, "To Next ' \" `")
  -- Subword
  map(ox, "as", function() t.subword("outer") end, "Subword")
  map(ox, "is", function() t.subword("inner") end, "Subword")
  -- map(ox, "aS", "as", "sentence")
  -- map(ox, "iS", "is", "sentence")
  -- current lines. Outer include indent
  map(ox, "i<Cr>", function() t.lineCharacterwise("inner") end, "Line")
  map(ox, "a<Cr>", function() t.lineCharacterwise("outer") end, "Line")
  -- Comment:
  -- map(ox,"gc", function() t.multiCommentedLines() end, "Comment")
  -- map(ox, "i<S-Tab>", function() t.nearEoL() end, "To Line End")
  -- map(ox, "a<S-Tab>", function() t.nearEoL() end, "To Line End")
  -- chain member
  map(ox, "iM", function() t.chainMember("inner") end, "Chain Function")
  map(ox, "aM", function() t.chainMember("outer") end, "Chain Function")
  -- Key/value
  map(ox, "i1", function() t.key("inner") end, "Key (KV)")
  map(ox, "a1", function() t.key("outer") end, "Key (KV)")
  map(ox, "i2", function() t.value("inner") end, "Value (KV)")
  map(ox, "a2", function() t.value("outer") end, "Value (KV)")
  -- Entire content
  map(ox, "ie", function() t.entireBuffer() end, "Entire Content")
  map(ox, "ae", function() t.entireBuffer() end, "Entire Content")
  map(ox, "aE", function() t.visibleInWindow() end, "Visible Content")
  map(ox, "iE", function() t.visibleInWindow() end, "Visible Content")
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
