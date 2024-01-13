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

local util = require("snippets.util")

-- Get T from string like "T, U: Debug"
local get_undefined_generics = function(str)
  str = str:sub(2, #str - 1)
  local generics = {}
  for generic in string.gmatch(str, "[^,]+") do
    if not string.find(generic, ":") then
      local result = string.match(generic, "^%s*(.-)%s*$")
      table.insert(generics, result)
    end
  end
  return generics
end

local generics_bound = function(pos)
  return c(pos, {
    -- util.empty_sn(),
    sn(nil, fmt(" <{}>", { i(1, "T") }), nil, "<T>"),
    sn(
      nil,
      fmt(" <{}: {}>", {
        i(1, "T"),
        i(2, "ToString"),
      }),
      nil,
      "<T: ToString>"
    ),
  })
end

local where_clause = function(pos, generic_pos)
  return d(pos, function(args) -- where clause
    local generics = get_undefined_generics(args[1][1])
    if #generics == 0 then
      return sn(nil, { t(" ") })
    else
      local nodes = { t({ "", "where" }) }
      for idx, v in ipairs(generics) do
        table.insert(nodes, t({ "", "\t" .. v .. ": " }))
        table.insert(nodes, i(idx, "ToString"))
        table.insert(nodes, t(","))
      end
      table.insert(nodes, t({ "", "" }))
      return sn(nil, nodes)
    end
  end, { generic_pos })
end

return {
  s(
    "type",
    fmt("{modifier}{space}type {} = {};", {
      modifier = util.rust.modifier(1),
      space = n(1, " "),
      i(2, "Foo"),
      i(3, "Bar"),
    }, { condition = conds_expand.line_end })
  ),
  s(
    "mod",
    fmt("{modifier}{space}mod {};", {
      modifier = util.rust.modifier(1),
      space = n(1, " "),
      i(2),
    }),
    { condition = conds_expand.line_end }
  ),
  s({ trig = "struct", desc = "struct {...}" }, {
    t({ "#[derive(Debug, Clone)]", "" }),
    util.rust.modifier(1),
    n(1, " "),
    t("struct "),
    i(2, "Foo"),
    -- generic
    n(3, "<"),
    i(3, "T: Display"), -- generics
    n(3, ">"),
    -- {...}
    t({ " {", "\t" }),
    util.rust.modifier(4),
    n(4, " "),
    i(5, "bar"),
    t(": "),
    i(6, "Bar"),
    t({ ",", "}" }),
  }, { condition = conds_expand.line_end }),
  s({ trig = "struct tuple", desc = "struct(..)" }, {
    t({ "#[derive(Debug, Clone)]", "" }),
    util.rust.modifier(1),
    n(1, " "),
    t("struct "),
    i(2, "Foo"),
    -- generic
    n(3, "<"),
    i(3, "T: Display"), -- generics
    n(3, ">"),
    t("("),
    i(4, "Bar"),
    t(");"),
  }, { condition = conds_expand.line_end }),
  s("enum", {
    util.rust.modifier(1),
    n(1, " "),
    t("enum "),
    i(2, "Foo"),
    t({ " {", "\t" }),
    i(3, "Foo1"),
    t({ ",", "\t" }),
    i(4, "Foo2(uint)"),
    t({ ",", "}" }),
  }, { condition = conds_expand.line_end }),
  s("fn", {
    util.rust.modifier(1),
    n(1, " "),
    t("fn "), -- fn keyword
    i(2, "foo"), -- fn name
    generics_bound(5),
    -- n(5, "<"),
    -- i(5, "T: ToString"), -- generics
    -- n(5, ">"),
    t("("),
    c(3, { -- receiver
      util.empty_sn(),
      t("self"),
      t("&self"),
      t("&mut self"),
    }),
    n(3, ", "),
    i(4), -- fn args
    t(")"),
    n(6, " -> "),
    i(6, "Result<(), ()>"), -- return type
    where_clause(7, 5),
    util.rust.body(0),
  }, { condition = conds_expand.line_end }),
  s("impl", {
    t("impl"),
    generics_bound(3),
    t(" "),
    i(1, "Type"),
    n(2, "<"),
    i(2, "T"),
    n(2, "> "),
    where_clause(4, 3),
    -- Body
    util.rust.body(0, true),
    -- }, { condition = conds_expand.line_begin * conds_expand.line_end }),
  }, { condition = conds_expand.line_end }),
  s("impl for", {
    t("impl"),
    generics_bound(5),
    t(" "),
    i(1, "Trait"),
    d(2, function(args)
      if #args[1][1] > 0 then
        return sn(nil, {
          n(1, "<"),
          i(1, "T"),
          n(1, ">"),
        })
      else
        return sn(nil, { t("") })
      end
    end, { 1 }),
    f(function(args)
      return #args[1][1] > 0 and " for " or ""
    end, { 1 }),
    i(3, "Type"),
    n(4, "<"),
    i(4, "T"),
    n(4, "> "),
    where_clause(6, 5),
    -- Body
    util.rust.body(0, true),
  }, { condition = conds_expand.line_end }),
  s("trait", {
    util.rust.modifier(1),
    n(1, " "),
    t("trait "),
    i(2, "Type"),
    n(3, "<"),
    i(3, "T"),
    n(3, ">"),
    t({ " {", "\t" }),
    n(4, "type "),
    i(4, "Item"),
    n(4, " = "),
    d(5, function(args)
      if args[1][1] ~= "" then
        return sn(nil, { i(1, "usize") })
      else
        return sn(nil, {})
      end
    end, { 4 }),
    n(4, ";"),
    i(0),
    t({ "", "\t" }),
    t({ "", "}" }),
  }, { condition = conds_expand.line_end }),
  s(
    { trig = "const", desc = "const ...: ... = ...;" },
    fmt("const {}: {} = {};", {
      i(1, "CONSTANT_VAR"),
      i(2, "Type"),
      i(3, "init"),
    }),
    { condition = conds_expand.line_end }
  ),
}
