local cmp = require("cmp")
local CompletionItemKind = cmp.lsp.CompletionItemKind
local lua_filters = {
  CompletionItemKind.Snippet,
  CompletionItemKind.Keyword,
  CompletionItemKind.Event, -- postfix
}

-- TODO: test to see if removing all Keyword
local rust_keyword_filters = {
  "if",
  "match",
  "if let",
  "while",
  "while let",
  "let",
  "fn",
  "struct",
  "impl",
  "trait",
  "pub",
  "pub(crate)",
  "pub(super)",
}

local rust_enum_filters = {
  "Ok(…)",
  "Some(…)",
  "Err(…)",
}

local rust_snippet_filters = {
  -- https://rust-analyzer.github.io/manual.html#format-string-completion
  "println",
  "print",
  "format",
  "panic",
  "logd",
  "logt",
  "logi",
  "logw",
  "loge",
  -- https://rust-analyzer.github.io/manual.html#magic-completions
  -- https://github.com/Veykril/rust-analyzer/blob/master/crates/ide-completion/src/tests/expression.rs
  -- https://github.com/Veykril/rust-analyzer/blob/master/crates/ide-completion/src/completions/keyword.rs
  "if",
  "match",
  "while",
  "ref",
  "refm",
  "deref",
  "let",
  "lete",
  "letm",
  "not",
  "dbg",
  "dbgr",
  "call",
  "return",
  -- rust-analyzer.completion.snippets.custom
  "arc",
  "rc",
  "box",
  "pinbox",
  "ok",
  "err",
  "some",
}
local M = {
  luasnip = {
    max_item_count = 100,
    entry_filter = function(entry, ctx)
      local label = entry.completion_item.label
      local cursor_before_line = ctx.cursor_before_line
      -- Do not show postfix
      return label:sub(1, 1) ~= "."

      -- -- Do not show snip after .
      -- if label:sub(1, 1) ~= "." and cursor_before_line:match("%.[%w_-]*$") then
      --   return false
      -- end

      -- Show postfix only after @ (prefix)
      -- if entry.completion_item.label:sub(1, 1) == "@" then
      --   return ctx.cursor_before_line:sub(-1) == "@"
      -- end

      -- return true
    end,
    option = {
      use_show_condition = true,
      show_autosnippets = true,
    },
  },
  nvim_lsp = {
    entry_filter = function(entry, ctx)
      local ft = ctx.filetype
      local kind = entry:get_kind()
      local label = entry.completion_item.label
      if ft == "lua" then
        return not vim.tbl_contains(lua_filters, kind)
      elseif ft == "rust" then
        if kind == CompletionItemKind.Keyword then
          return not vim.tbl_contains(rust_keyword_filters, label)
        elseif kind == CompletionItemKind.EnumMember then
          return not vim.tbl_contains(rust_enum_filters, label)
        elseif kind == CompletionItemKind.Snippet then
          return not vim.tbl_contains(rust_snippet_filters, label)
        end
      end
      return true
    end,
  },
  buffer = {
    keyword_length = 3,
    max_item_count = 10,
    entry_filter = function(entry, ctx)
      return not entry.exact -- Filter out if it is exactly match
    end,
  },
}

return M
