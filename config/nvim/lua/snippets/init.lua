-- References:
-- * https://github.com/L3MON4D3/LuaSnip/blob/master/Examples/snippets
-- * Examples: https://github.com/molleweide/LuaSnip-snippets.nvim
local ls = require("luasnip")

-- NOTE: Using jimzk/cmp-luasnip-choice to complete choice node by cmp requires the nested snippet node has
-- the field docstring, otherwise a error will be thrown. And we can't customized what is shown in completion menu either..
-- Reproduction snippet: the snippet "class" in https://github.com/L3MON4D3/LuaSnip/blob/master/Examples/snippets#L214-L244
-- This is a wordaound.
local _sn = ls.snippet_node
ls.snippet_node = function(pos, nodes, opts, docstring)
  local node = _sn(pos, nodes, opts)
  node.docstring = type(docstring) == "string" and { docstring } or docstring
  return node
end

local _c = ls.choice_node
ls.choice_node = function(jump_index, choices, node_opts)
  -- Need to append a t otherwise choice menu won't show up
  table.insert(choices, 1, ls.t(""))
  return _c(jump_index, choices, node_opts)
end

local wrap = function(context, nodes, opts)
  if type(context) == "string" then
    context = { trig = context }
  end
  if not context.docstring then
    context.docstring = ""
  end
  return context, nodes, opts
end

local _s = ls.snippet
ls.snippet = function(context, nodes, opts)
  opts = opts or {}
  -- NOTE: experimental.
  if not opts.show_condition and opts.condition then
    opts.show_condition = function(line_to_cursor)
      -- NOTE: Get the real line_to_cursor before trigger text. Seems like a BUG.
      line_to_cursor = string.sub(line_to_cursor, 1, -2)
      return opts.condition(line_to_cursor .. context.trig, context.trig)
    end
  end
  context, nodes, opts = wrap(context, nodes, opts)
  return _s(context, nodes, opts)
end

local postfix_trigger = "."
local postfix = require("luasnip.extras.postfix")
local _pf = postfix.postfix
postfix.postfix = function(context, nodes, opts)
  opts = opts or {}
  context, nodes, opts = wrap(context, nodes, opts)
  if not context.disabled_prefix then
    context.trig = postfix_trigger .. context.trig -- add prefix
  end
  if context.match_pattern == nil then
    -- match pattern: start with alphanum , _ ( ) : < >
    -- default is [%w%.%_%-]+$
    -- See https://zjp-cn.github.io/neovim0.6-blogs/nvim/luasnip/doc1.html#postfix
    context.match_pattern = "[%w%.%_%(%):<>]+$"
  end
  -- Default is 1000. Make sure postfix is the highest priority.
  context.priority = 2000
  opts = opts and opts or {}
  if not opts.show_condition then
    if opts.condition then
      opts.show_condition = function(line_to_cursor)
        return opts.condition(line_to_cursor, context.trig)
      end
    else
      opts.show_condition = function(line_to_cursor)
        -- Show only after trigger
        return line_to_cursor:match("[%w_-]+.[%w_-]*$") ~= nil
      end
    end
  end
  return _pf(context, nodes, opts)
end

local ts_postfix = require("luasnip.extras.treesitter_postfix")
local _ts_postfix = ts_postfix.treesitter_postfix
ts_postfix.treesitter_postfix = function(context, nodes, opts)
  opts = opts or {}
  if not context.disabled_prefix then
    context.trig = postfix_trigger .. context.trig -- add prefix
  end
  -- if not opts.show_condition and opts.condition then
  --   opts.show_condition = function(line_to_cursor)
  --     line_to_cursor = string.sub(line_to_cursor, 1, -3)
  --     return opts.condition(line_to_cursor .. context.trig, context.trig)
  --   end
  -- end
  context, nodes, opts = wrap(context, nodes, opts)
  return _ts_postfix(context, nodes, opts)
end

local snippets = {
  rust = {
    "postfix",
    "keyword",
    "format",
    "test",
    "type",
    "impl",
    "misc",
  },
  lua = {
    "keyword",
    "postfix",
    "ts_postfix",
    "nvim",
  },
}

for lang, packages in pairs(snippets) do
  for _, package in ipairs(packages) do
    ls.add_snippets(lang, require("snippets." .. lang .. "." .. package))
  end
end

-- require("snippets.example")
