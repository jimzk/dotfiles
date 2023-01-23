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
  map(ox, "iu", t.url, "url")
  -- camel case word
  map(ox, "i<C-w>", function() t.subword(true) end, "camel case word")
  map(ox, "a<C-w>", function() t.subword(false) end, "camel case word")
  -- Key/value
  map(ox, "iV", function() t.value(true) end, "value (KV)")
  map(ox, "aV", function() t.value(false) end, "value (KV)")
  map(ox, "iK", function() t.key(true) end, "key (KV)")
  map(ox, "aK", function() t.key(false) end, "key (KV)")
  -- entire content
  map(ox, "ie", function() t.entireBuffer() end, "entire content")
  map(ox, "ae", function() t.entireBuffer() end, "entire content")
  -- column down
  -- map(ox, "i|", function() t.column() end, "column down")
  -- Number
  map(ox, "iR", function() t.number(true) end, "number")
  map(ox, "aR", function() t.number(false) end, "number")

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
