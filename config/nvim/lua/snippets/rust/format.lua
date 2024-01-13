local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local n = require("luasnip.extras").nonempty
local fmt = require("luasnip.extras.fmt").fmt
local conds_expand = require("luasnip.extras.conditions.expand")

local has_args_captured = function(str)
  if string.find(str, "%{%}") or string.find(str, "{:%?}") then
    return true
  end
  return false
end

local last_comma = function(args, snip, old_state)
  if has_args_captured(args[1][1]) then
    return sn(nil, { t(", "), i(1) })
  else
    return sn(nil, {})
  end
end

local format_call = function(trig, method, prefix)
  return s(
    {
      trig = trig,
      desc = method .. "(...);",
    },
    fmt(method .. '({prefix}"{desc}"{comma});', {
      prefix = t(prefix),
      desc = i(1),
      comma = d(2, last_comma, { 1 }),
    })
  )
end

-- macro with format input
ls.add_snippets("rust", {
  -- format_call("println", "println!"),
  -- format_call("fmt", "format!"),
  -- format_call("todo", "todo!"),

  format_call("prl", "println!"),
  format_call("pr", "print!"),
  format_call("fmt", "format!"),
  -- format_call("panic", "panic!"),
  -- format_call("td", "todo!"),
  s("pc", fmt("panic!({});", { i(1) })),
  s("dbg", fmt("dbg!({});", { i(1) })),
  s("td", fmt("todo!({});", { i(1) })),
  format_call("write!", "write!", "f, "),
  format_call("writeln!", "writeln!", "f, "),
  format_call("logd", "log::debug!"),
  format_call("logt", "log::trace!"),
  format_call("logi", "log::info!"),
  format_call("logw", "log::warn!"),
  format_call("loge", "log::error!"),
})

-- assert, assert_eq, assert_ne
return {
  s(
    {
      trig = "a", -- a
      desc = "assert!(a[, desc][, var]);",
    },
    fmt("assert!({1}{comma1}{desc}{comma2});", {
      i(1, "a"),
      comma1 = n(2, ", "), -- show , if i_2 is nonempty
      desc = d(2, function(args)
        return sn(nil, i(1, string.format('"assert %s is true', args[1][1])))
      end, { 1 }), -- get i_1
      comma2 = d(3, last_comma, { 2 }), -- show comma according to i_2
    }),
    { condition = conds_expand.line_begin }
  ),
  s(
    {
      trig = "aeq", -- ane
      desc = "assert_eq!(a, b[, desc][, var]);",
    },
    fmt("assert_eq!({1}, {2}{comma1}{desc}{comma2});", {
      i(1, "a"),
      i(2, "b"),
      comma1 = n(3, ", "), -- show ',' if i_3 is nonempty
      desc = d(3, function(args)
        return sn(nil, i(1, string.format('"assert_eq: %s = {}, %s = {}"', args[1][1], args[2][1])))
      end, { 1, 2 }), -- default description
      comma2 = d(4, function(args)
        local a = args[1][1]
        local b = args[2][1]
        local desc = args[3][1]
        local default_desc = string.format('"assert_eq: %s = {}, %s = {}"', a, b)
        if desc == default_desc then -- show ',a ,b' for default desc
          return sn(nil, { t(", " .. a), t(", " .. b) })
        elseif has_args_captured(desc) then
          return sn(nil, { t(", "), i(1) })
        else
          return sn(nil, {})
        end
      end, { 1, 2, 3 }),
    }),
    { condition = conds_expand.line_begin }
  ),
  s(
    {
      trig = "ane", -- ane
      desc = "assert_ne!(a, b[, desc][, var]);",
    },
    fmt("assert_ne!({1}, {2}{comma1}{desc}{comma2});", {
      i(1, "a"),
      i(2, "b"),
      comma1 = n(3, ", "), -- show ',' if i_3 is nonempty
      desc = d(3, function(args)
        return sn(nil, i(1, string.format('"assert_ne: %s = {}, %s = {}"', args[1][1], args[2][1])))
      end, { 1, 2 }), -- default description
      comma2 = d(4, function(args)
        local a = args[1][1]
        local b = args[2][1]
        local desc = args[3][1]
        local default_desc = string.format('"assert_ne: %s = {}, %s = {}"', a, b)
        if desc == default_desc then
          return sn(nil, { t(", " .. a), t(", " .. b) })
        elseif has_args_captured(desc) then
          return sn(nil, { t(", "), i(1) })
        else
          return sn(nil, {})
        end
      end, { 1, 2, 3 }),
    }),
    { condition = conds_expand.line_begin }
  ),
}
