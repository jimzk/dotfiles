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

-- -- https://zjp-cn.github.io/neovim0.6-blogs/nvim/luasnip/doc1.html#postfix
-- local postfix_fn = function(trig, method, opts)
--   return postfix({
--     trig = trig,
--     desc = method .. "(…)",
--   }, {
--     f(function(_, parent)
--       local text = parent.snippet.env.POSTFIX_MATCH
--       if not text then
--         vim.notify("Invalid Pattern", vim.log.levels.WARN, { title = "LuaSnip" })
--         return
--       end
--       return method .. "(" .. text .. ")"
--     end),
--   })
-- end
--
-- local postfix_type = function(trig, type)
--   return postfix({
--     trig = trig,
--     desc = type .. "<…>",
--   }, {
--     f(function(_, parent)
--       local text = parent.snippet.env.POSTFIX_MATCH
--       if not text then
--         vim.notify("Invalid Pattern", vim.log.levels.WARN, { title = "LuaSnip" })
--         return
--       end
--       local prefix = string.match(text, "^[%s<]+") or ""
--       text = text:gsub("^[%s<]+", "")
--       return prefix .. type .. "<" .. text .. ">"
--     end),
--   })
-- end
--
-- local postfix_format = function(trig, method)
--   return postfix({
--     trig = trig,
--     desc = method .. "(…)",
--     docstring = '"foo {bar}" -> ' .. method .. '("foo {}", bar);',
--     match_pattern = '".*"',
--   }, {
--     f(function(_, parent)
--       local text = parent.snippet.env.POSTFIX_MATCH
--       local vars = {}
--       for word in string.gmatch(text, "{(.-)}") do
--         table.insert(vars, word)
--       end
--       local str = string.gsub(text, "{.-}", "{}")
--       if #vars >= 1 then
--         str = str .. ", " .. table.concat(vars, ", ")
--       end
--       return method .. "(" .. str .. ");"
--     end),
--   }, {
--     show_condition = function(line_to_cursor)
--       return line_to_cursor:match('".[%w_-]*$') ~= nil
--     end,
--   })
-- end

local for_choice_c = function(pos)
  return c(pos, {
    sn(nil, fmt("Ok({}) = {}", { i(1), l(l.POSTFIX_MATCH) }), nil, "Ok(…) = expr", true),
    sn(nil, fmt("Some({}) = {}", { i(1), l(l.POSTFIX_MATCH) }), nil, "Some(…) = expr", true),
    sn(nil, fmt("{} = {}", { i(1, "Foo::Bar"), l(l.POSTFIX_MATCH) }), nil, "Enum::… = expr", true),
  })
end

-- Rust analyzer postfix. See https://rust-analyzer.github.io/manual.html
-- * https://rust-analyzer.github.io/manual.html#magic-completions
local M = {
  -- https://rust-analyzer.github.io/manual.html#user-snippet-completions
  postfix({ trig = "arc", desc = "Arc::new(…)" }, fmt("Arc::new({}){}", { l(l.POSTFIX_MATCH), i(0) })),
  postfix({ trig = "box", desc = "Box::new(…)" }, fmt("Box::new({}){}", { l(l.POSTFIX_MATCH), i(0) })),
  postfix({ trig = "boxpin", desc = "Box::pin(…)" }, fmt("Box::pin({}){}", { l(l.POSTFIX_MATCH), i(0) })),
  postfix({ trig = "ok", desc = "Ok(…)" }, fmt("Ok({}){}", { l(l.POSTFIX_MATCH), i(0) })),
  postfix({ trig = "err", desc = "Err(…)" }, fmt("Err({}){}", { l(l.POSTFIX_MATCH), i(0) })),
  postfix({ trig = "some", desc = "Some(…)" }, fmt("Some({}){}", { l(l.POSTFIX_MATCH), i(0) })),
  postfix({ trig = "string", desc = "String::from(…)" }, fmt("String::from({}){}", { l(l.POSTFIX_MATCH), i(0) })),

  --
  -- Type postfix
  -- postfix_type("option", "Option"), -- foo@option<tab> -> Option<Foo>
  -- postfix_type("vec", "Vec"),
  --
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

  postfix({
    trig = "println",
    desc = 'println!("x = {}", x);',
  }, fmt([[println!("{} = {{}}", {});{}]], { dl(1, l.POSTFIX_MATCH, {}), l(l.POSTFIX_MATCH), i(0) })),
  postfix({
    trig = "panic",
    desc = 'panic!("x = {}", x);',
  }, fmt([[panic!("{} = {{}}", {});{}]], { dl(1, l.POSTFIX_MATCH, {}), l(l.POSTFIX_MATCH), i(0) })),
  postfix({
    trig = "format",
    desc = 'format!("x = {}", x);',
  }, fmt([[format!("{} = {{}}", {});{}]], { dl(1, l.POSTFIX_MATCH, {}), l(l.POSTFIX_MATCH), i(0) })),
  postfix({
    trig = "unsafe",
    desc = "unsafe { expr }",
  }, fmt([[unsafe {{ {} }}{}]], { l(l.POSTFIX_MATCH), i(0) })),
  s({
    trig = "unsafe",
    desc = "unsafe { expr }",
  }, fmt("unsafe {{{}}}", { i(0) })),
  postfix({
    trig = "unsafe",
    desc = "unsafe { expr }",
    disabled_prefix = true,
    match_pattern = "[%w%.%_%(%):<>]+;$",
  }, fmt([[unsafe {{ {} }}{}]], { l(l.POSTFIX_MATCH), i(0) })),

  -- https://rust-analyzer.github.io/manual.html#magic-completions
  postfix({ trig = "let", desc = "let … = expr;" }, fmt("let {} = {};", { i(1), l(l.POSTFIX_MATCH) })),
  postfix({ trig = "letm", desc = "let mut … = expr;" }, fmt("let mut {} = {};", { i(1), l(l.POSTFIX_MATCH) })),
  postfix({ trig = "return", desc = "return expr;" }, fmt("return {};", { l(l.POSTFIX_MATCH) })),
  postfix({ trig = "dbg", desc = "dbg!(expr);" }, fmt("dbg!({});", { l(l.POSTFIX_MATCH) })),
  postfix({ trig = "dbgr", desc = "dbg!(&expr);" }, fmt("dbg!(&{});", { l(l.POSTFIX_MATCH) })),
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
    { trig = "while", desc = "while expr {}" },
    fmt(
      [[
    while {} {{
        {}
    }}]],
      { l(l.POSTFIX_MATCH), i(0) }
    )
  ),
  postfix(
    { trig = "if let", desc = "if let … = expr { … }" },
    fmt(
      [[
    if let {} {{
        {}
    }}]],
      { for_choice_c(1), i(0) }
    )
  ),
  postfix(
    { trig = "while let", desc = "while let … = expr { … }" },
    fmt(
      [[
    while let {} {{
        {}
    }}]],
      { for_choice_c(1), i(0) }
    )
  ),
  postfix(
    { trig = "match", desc = "match expr {}" },
    fmt(
      [[
    match {} {{
        {}
    }}]],
      { l(l.POSTFIX_MATCH), i(0) }
    )
  ),
  s(
    {
      trig = ":",
      desc = "i: i32",
    },
    fmt("{}: {}{}", { i(2, "i"), i(1, "i32"), i(0) }),
    {
      condition = conds_expand.line_after_space,
      show_condition = conds_expand.always_false,
    }
  ),
  postfix({
    trig = ":",
    desc = "i : usize",
    disabled_prefix = true,
    match_pattern_postfix = "[%w>]+$",
    -- match_pattern = "[%w%.%_%(%):<>]+$",
  }, fmt("{} : {}{}", { i(1), l(l.POSTFIX_MATCH), i(0) }), { show_condition = conds_expand.always_false }),
  postfix({
    trig = ")",
    desc = "…(expr)",
    disabled_prefix = true,
    -- match_pattern = "[%w%.%_%(%):<>]+$",
  }, fmt("{}({})", { i(1), l(l.POSTFIX_MATCH) }), { show_condition = conds_expand.always_false }),
}

vim.list_extend(M, {
  postfix({
    trig = ">",
    desc = "…<T>",
    disabled_prefix = true,
    priority = 3000,
    match_pattern = "['%w_:,]+$",
  }, fmt("{}<{}>{}", { i(1), l(l.POSTFIX_MATCH), i(0) }), { show_condition = conds_expand.always_false }),
  postfix({
    trig = ",",
    desc = "(T, …)",
    disabled_prefix = true,
    priority = 3000,
    match_pattern = "['%w_:,]+$",
  }, fmt("({}, {}){}", { l(l.POSTFIX_MATCH), i(1), i(0) }), { show_condition = conds_expand.always_false }),
  postfix({
    trig = ">",
    desc = "…<T>",
    disabled_prefix = true,
    -- NOTE: limit: fail to complete (usize, usize><tab>), which expands to |<(usize, usize>)
    match_pattern = "[^ %)>,%-]['%w_%(%):<>, &]*[_%w>%)]$",
  }, fmt("{}<{}>{}", { i(1), l(l.POSTFIX_MATCH), i(0) }), { show_condition = conds_expand.always_false }),
  postfix({
    trig = ",",
    desc = "(T, …)",
    disabled_prefix = true,
    -- NOTE: limit: fail to complete (usize, usize,<tab>), which expands to ((usize, usize, |))
    match_pattern = "[^ %)>,%-]['%w_%(%):<>, &]*[_%w>%)]$",
  }, fmt("({}, {}){}", { l(l.POSTFIX_MATCH), i(1), i(0) }), { show_condition = conds_expand.always_false }),
})

-- not, ref, refm, deref
vim.list_extend(M, {
  postfix({
    trig = "!",
    desc = "!expr",
    disabled_prefix = true,
    -- match_pattern = "[!*&%w%_]+[%w%.%_:%(%)]*$",
  }, fmt("!{}", { l(l.POSTFIX_MATCH) })),
  postfix({
    trig = "&",
    desc = "&expr",
    disabled_prefix = true,
    -- match_pattern = "[!*&%w%_]+[%w%.%_:%(%)]*$",
  }, fmt("&{}", { l(l.POSTFIX_MATCH) })),
  postfix({
    trig = "&m",
    desc = "&mut expr",
    disabled_prefix = true,
    -- match_pattern = "[!*&%w%_]+[%w%.%_:%(%)]*$",
  }, fmt("&mut {}", { l(l.POSTFIX_MATCH) })),
  postfix({
    trig = "*",
    desc = "*expr",
    disabled_prefix = true,
    -- match_pattern = "[!*&%w%_]+[%w%.%_:%(%)]*$",
  }, fmt("*{}", { l(l.POSTFIX_MATCH) })),
})

return M
