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
  if str:sub(1, 1) == "<" then
    str = str:sub(2, #str - 1)
  end
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
      local idx = 1
      for _, v in ipairs(generics) do
        if string.sub(v, 1, 1) ~= "'" then -- skip lifetimes
          table.insert(nodes, t({ "", "\t" .. v .. ": " }))
          table.insert(nodes, i(idx, "ToString"))
          table.insert(nodes, t(","))
          idx = idx + 1
        end
      end
      table.insert(nodes, t({ "", "" }))
      return sn(nil, nodes)
    end
  end, { generic_pos })
end

local line_self = conds.make_condition(function(line_to_cursor, matched_trigger)
  local str = line_to_cursor:sub(1, -(#matched_trigger + 1))
  local lastChar = string.sub(str, -1)
  return lastChar == " " or lastChar == "(" or lastChar == ""
end)

return {
  -- s({ trig = "self", desc = "self" }, fmt("self", {}), { condition = line_self }),
  s({ trig = "self&", desc = "&self", priority = 3000 }, fmt("&self", {}), { condition = line_self }),
  s({ trig = "self&m", desc = "&mut self", priority = 3000 }, fmt("&mut self", {}), { condition = line_self }),
  -- s({ trig = "self.", desc = "self." }, fmt("self.{}", { i(1) }), { condition = line_self }),

  -- s(
  --   "t",
  --   fmt("{modifier}{space}type {} = {};", {
  --     modifier = util.rust.modifier(1),
  --     space = n(1, " "),
  --     i(2, "Foo"),
  --     i(3, "Bar"),
  --   })
  -- ),
  s(
    "type",
    fmt("type {} = {};{}", {
      i(1, "Foo"),
      i(2, "i32"),
      i(0),
    }),
    {
      condition = conds_expand.rust_definition,
    }
  ),
  s(
    "mod",
    fmt("mod {};", {
      i(1),
    }),
    {
      condition = conds_expand.rust_definition,
    }
  ),
  -- s({ trig = "struct", desc = "struct {...}" }, {
  --   t({ "#[derive(Debug, Clone, Default, Eq, PartialEq, Ord, PartialOrd)]", "" }),
  --   util.rust.modifier(1),
  --   n(1, " "),
  --   t("struct "),
  --   i(2, "Foo"),
  --   -- generic
  --   n(3, "<"),
  --   i(3, "T: Display"), -- generics
  --   n(3, ">"),
  --   -- {...}
  --   t({ " {", "\t" }),
  --   util.rust.modifier(4),
  --   n(4, " "),
  --   i(5, "bar"),
  --   t(": "),
  --   i(6, "Bar"),
  --   t({ ",", "\t" }),
  --   i(0),
  --   t({ "", "}" }),
  -- }),
  s({ trig = "struct", desc = "struct {...}" }, {
    t("struct "),
    i(1, "Foo"),
    -- generic
    n(2, "<"),
    i(2, "T: Display"), -- generics
    n(2, ">"),
    t({ " {", "\t" }),
    i(3, "bar"),
    t(": "),
    i(4, "i32"),
    t({ "," }),
    i(0),
    t({ "", "}" }),
  }, {
    condition = conds_expand.rust_definition,
  }),
  s({ trig = "struct(…)", desc = "struct(…)" }, {
    t("struct "),
    i(1, "Foo"),
    -- generic
    n(2, "<"),
    i(2, "T: Display"), -- generics
    n(2, ">"),
    t("("),
    i(3, "i32"),
    t(");"),
  }, {
    condition = conds_expand.rust_definition,
  }),
  s("enum", {
    t("enum "),
    i(1, "Foo"),
    t({ " {", "\t" }),
    i(2, "Foo1"),
    t({ ",", "\t" }),
    i(3, "Foo2(uint)"),
    t({ ",", "}" }),
  }, {
    condition = conds_expand.rust_definition,
  }),
  -- s("fn", {
  --   util.rust.modifier(1),
  --   n(1, " "),
  --   t("fn "), -- fn keyword
  --   i(2, "foo"), -- fn name
  --   generics_bound(5),
  --   -- n(5, "<"),
  --   -- i(5, "T: ToString"), -- generics
  --   -- n(5, ">"),
  --   t("("),
  --   c(3, { -- receiver
  --     util.empty_sn(),
  --     t("self"),
  --     t("&self"),
  --     t("&mut self"),
  --   }),
  --   n(3, ", "),
  --   i(4), -- fn args
  --   t(")"),
  --   n(6, " -> "),
  --   i(6, "Result<(), ()>"), -- return type
  --   where_clause(7, 5),
  --   util.rust.body(0),
  -- }),
  s("fn", {
    t("fn "), -- fn keyword
    i(1), -- fn name
    generics_bound(3),
    t("("),
    -- i(2, "a: i32"), -- fn args
    i(2), -- fn args
    t(")"),
    n(4, " -> "),
    i(4, "Result<(), ()>"), -- return type
    where_clause(5, 3),
    -- Body
    t({ "{", "\t" }),
    i(0, "todo!()"),
    t({ "", "}" }),
  }, {
    condition = conds_expand.rust_definition,
  }),
  s("impl", {
    t("impl"),
    -- generics_bound(3),
    f(function(args)
      return #args[1][1] > 0 and "<" .. args[1][1] .. ">" or ""
    end, { 2 }),
    t(" "),
    i(1, "Type"),
    n(2, "<"),
    i(2, "T"),
    n(2, "> "),
    where_clause(3, 2),
    -- Body
    t({ "{", "\t" }),
    i(0),
    t({ "", "}" }),
    -- }, { condition = conds_expand.line_begin * conds_expand.line_end }),
  }, {
    condition = conds_expand.line_begin,
  }),
  s("impl for", {
    t("impl"),
    -- generics_bound(5),
    f(function(args)
      return #args[1][1] > 0 and "<" .. args[1][1] .. ">" or ""
    end, { 3 }),
    t(" "),
    i(1, "Trait"),
    -- d(2, function(args)
    --   if #args[1][1] > 0 then
    --     return sn(nil, {
    --       n(1, "<"),
    --       i(1, "T"),
    --       n(1, ">"),
    --     })
    --   else
    --     return sn(nil, { t("") })
    --   end
    -- end, { 1 }),
    f(function(args)
      return #args[1][1] > 0 and " for " or ""
    end, { 1 }),
    i(2, "Type"),
    n(3, "<"),
    i(3, "T"),
    n(3, "> "),
    where_clause(4, 3),
    -- Body
    t({ "{", "\t" }),
    i(0),
    t({ "", "}" }),
  }, {
    condition = conds_expand.line_begin,
  }),
  s("trait", {
    t("trait "),
    i(1, "Type"),
    n(2, "<"),
    i(2, "T"),
    n(2, ">"),
    t({ " {", "\t" }),
    n(3, "type "),
    i(3, "Item"),
    n(3, " = "),
    d(4, function(args)
      if args[1][1] ~= "" then
        return sn(nil, { i(1, "usize") })
      else
        return sn(nil, {})
      end
    end, { 3 }),
    n(3, ";"),
    t({ "", "\t" }),
    t("fn "),
    i(5),
    t("("),
    i(6),
    t(")"),
    n(7, " -> "),
    i(7, "usize"), -- return type
    t(";"),
    t({ "", "}" }),
  }, {
    condition = conds_expand.rust_definition,
  }),
  s(
    { trig = "const", desc = "const ...: ... = ...;" },
    fmt("const {}: {} = {};", {
      i(1, "CONSTANT_VAR"),
      i(2, "Type"),
      i(3, "init"),
    }),
    { condition = conds_expand.line_begin }
  ),
}
