local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")
local pf = require("snippets.util").postfix
local postfix = require("luasnip.extras.postfix").postfix

-- https://zjp-cn.github.io/neovim0.6-blogs/nvim/luasnip/doc1.html#postfix
local postfix_fn = function(trig, method, opts)
  return postfix({
    trig = trig,
    desc = method .. "(…)",
  }, {
    f(function(_, parent)
      local text = parent.snippet.env.POSTFIX_MATCH
      if not text then
        vim.notify("Invalid Pattern", vim.log.levels.WARN, { title = "LuaSnip" })
        return
      end
      return method .. "(" .. text .. ")"
    end),
  })
end

local postfix_type = function(trig, type)
  return postfix({
    trig = trig,
    desc = type .. "<…>",
  }, {
    f(function(_, parent)
      local text = parent.snippet.env.POSTFIX_MATCH
      if not text then
        vim.notify("Invalid Pattern", vim.log.levels.WARN, { title = "LuaSnip" })
        return
      end
      local prefix = string.match(text, "^[%s<]+") or ""
      text = text:gsub("^[%s<]+", "")
      return prefix .. type .. "<" .. text .. ">"
    end),
  })
end

local postfix_format = function(trig, method)
  return postfix({
    trig = trig,
    desc = method .. "(…)",
    docstring = '"foo {bar}" -> ' .. method .. '("foo {}", bar);',
    match_pattern = '".*"',
  }, {
    f(function(_, parent)
      local text = parent.snippet.env.POSTFIX_MATCH
      local vars = {}
      for word in string.gmatch(text, "{(.-)}") do
        table.insert(vars, word)
      end
      local str = string.gsub(text, "{.-}", "{}")
      if #vars >= 1 then
        str = str .. ", " .. table.concat(vars, ", ")
      end
      return method .. "(" .. str .. ");"
    end),
  }, {
    show_condition = function(line_to_cursor)
      return line_to_cursor:match('".[%w_-]*$') ~= nil
    end,
  })
end

local for_choice_c = function(pos)
  return c(pos, {
    sn(nil, fmt("Ok({}) = {}", { i(1), l(l.POSTFIX_MATCH) }), nil, "Ok(…) = expr", true),
    sn(nil, fmt("Some({}) = {}", { i(1), l(l.POSTFIX_MATCH) }), nil, "Some(…) = expr", true),
    sn(nil, fmt("{} = {}", { i(1, "Foo::Bar"), l(l.POSTFIX_MATCH) }), nil, "Enum::… = expr", true),
  })
end

-- Rust analyzer postfix. See https://rust-analyzer.github.io/manual.html
-- * https://rust-analyzer.github.io/manual.html#magic-completions
return {
  -- https://rust-analyzer.github.io/manual.html#user-snippet-completions
  postfix_fn("arc", "Arc::new"), -- foo@arc<tab> -> Arc::new(foo)
  postfix_fn("rc", "rc::new"),
  postfix_fn("box", "Box::new"),
  postfix_fn("boxpin", "Box::pin"),
  postfix_fn("ok", "Ok"),
  postfix_fn("err", "Err"),
  postfix_fn("some", "Some"),
  -- Type postfix
  postfix_type("op", "Option"), -- foo@option<tab> -> Option<Foo>
  postfix_type("vec", "Vec"),
  -- Rust analyzer Format string completion
  -- https://rust-analyzer.github.io/manual.html#format-string-completion
  -- postfix_format("println", "println!"), -- "foo {bar}"@println<tab> -> println!("foo {}", bar)
  -- postfix_format("print", "print!"),
  -- postfix_format("format", "format!"),
  -- postfix_format("panic", "panic!"),
  -- postfix_format("logd", "log::debug!"),
  -- postfix_format("logt", "log::trace!"),
  -- postfix_format("logi", "log::info!"),
  -- postfix_format("logw", "log::warn!"),
  -- postfix_format("loge", "log::error!"),
  -- postfix({ trig = "dbg", desc = "dbg!(expr)" }, fmt("dbg!({})", { l(l.POSTFIX_MATCH) })),
  -- postfix({ trig = "dbgr", desc = "dbg!(&expr)" }, fmt("dbg!(&{})", { l(l.POSTFIX_MATCH) })),

  -- https://rust-analyzer.github.io/manual.html#magic-completions
  postfix({ trig = "l", desc = "let … = expr;" }, fmt("let {} = {};", { i(1), l(l.POSTFIX_MATCH) })),
  postfix({ trig = "lm", desc = "let mut … = expr;" }, fmt("let mut {} = {};", { i(1), l(l.POSTFIX_MATCH) })),
  postfix({ trig = "r", desc = "return expr;" }, fmt("return {};", { l(l.POSTFIX_MATCH) })),
  -- FIX: priority lower than if
  postfix(
    { trig = "if", desc = "if expr {}" },
    fmt(
      [[
    if {} {{
        {}
    }}]],
      { l(l.POSTFIX_MATCH), i(0) }
    )
  ),
  postfix(
    { trig = "w", desc = "while expr {}" },
    fmt(
      [[
    while {} {{
        {}
    }}]],
      { l(l.POSTFIX_MATCH), i(0) }
    )
  ),
  postfix(
    { trig = "ifl", desc = "if let … = expr { … }" },
    fmt(
      [[
    if let {} {{
        {}
    }}]],
      { for_choice_c(1), i(0) }
    )
  ),
  postfix(
    { trig = "wl", desc = "while let … = expr { … }" },
    fmt(
      [[
    while let {} {{
        {}
    }}]],
      { for_choice_c(1), i(0) }
    )
  ),
  postfix(
    { trig = "m", desc = "match expr {}" },
    fmt(
      [[
    match {} {{
        {}
    }}]],
      { l(l.POSTFIX_MATCH), i(0) }
    )
  ),
  -- not, ref, refm, deref
  postfix({
    trig = "-",
    desc = "…(expr)",
    disabled_prefix = true,
    -- match_pattern = "[%w%.%_%(%):<>]+$",
  }, fmt("{}({})", { i(1), l(l.POSTFIX_MATCH) })),
  postfix({
    trig = "!",
    desc = "!expr",
    disabled_prefix = true,
    match_pattern = "[%w%.%_:]+$",
  }, fmt("!{}", { l(l.POSTFIX_MATCH) })),
  postfix({
    trig = "&",
    desc = "&expr",
    disabled_prefix = true,
    match_pattern = "[%w%.%_:]+$",
    -- match_pattern = "[%w%.%_:]+[%w]$",
  }, fmt("&{}", { l(l.POSTFIX_MATCH) })),
  postfix({
    trig = "&m",
    desc = "&mut expr",
    disabled_prefix = true,
    match_pattern = "[%w%.%_:]+$",
  }, fmt("&mut {}", { l(l.POSTFIX_MATCH) })),
  postfix({
    trig = "*",
    desc = "*expr",
    disabled_prefix = true,
    -- match_pattern = "[%w%.%_:]+$",
  }, fmt("*{}", { l(l.POSTFIX_MATCH) })),
}
