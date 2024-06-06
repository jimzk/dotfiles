local ls = require("luasnip")
local t = ls.text_node
local i = ls.insert_node
local n = require("luasnip.extras").nonempty
local l = require("luasnip.extras").lambda
local fmt = require("luasnip.extras.fmt").fmt
local postfix = require("luasnip.extras.postfix").postfix

return {
  postfix({
    trig = "(l|local)",
    trigEngine = "ecma",
    name = "local",
    desc = "local … = x",
  }, { t("local "), i(1), l(" = " .. l.POSTFIX_MATCH) }),
  postfix({
    trig = "remove",
    desc = "remove item from list",
    docstring = "table.remove(x, i)",
  }, { t("table.remove("), l(l.POSTFIX_MATCH), t(", "), i(1, "1"), t(")") }),
  postfix({
    trig = "insert",
    desc = "insert item into list",
    docstring = "table.insert(x, [pos,] item)",
  }, {
    t("table.insert("),
    l(l.POSTFIX_MATCH),
    t(", "),
    i(1, "1"),
    n(1, ", "), -- if i_1 is non-empty, then add ", "
    i(2, "item"),
    t(")"),
  }),
  postfix({
    trig = "concat",
    desc = "concat list by separator",
    docstring = "table.concat(x, sep)",
  }, { t("table.concat("), l(l.POSTFIX_MATCH), t(', "'), i(1, " "), t('")') }),
  postfix(
    {
      trig = "if",
      desc = {
        "if … then",
        "…",
        "end",
      },
    },
    fmt(
      [[
      if {} then
        {}
      end
      ]],
      {
        l(l.POSTFIX_MATCH),
        i(1),
      }
    )
  ),
  postfix(
    {
      trig = "pairs",
      desc = "iterate table",
      docstring = { "for k, v in pairs(x) do", "\t-- do something", "end" },
    },
    fmt(
      [[
      for {}, {} in pairs({x}) do
        {}
      end
    ]],
      {
        i(1, "k"),
        i(2, "v"),
        i(3),
        x = l(l.POSTFIX_MATCH),
      }
    )
  ),
  postfix(
    {
      trig = "ipairs",
      desc = "iterate list",
      docstring = { "for i, v in ipairs(x) do", "\t-- do something", "end" },
    },
    fmt(
      [[
      for {}, {} in ipairs({x}) do
        {}
      end
    ]],
      {
        i(1, "i"),
        i(2, "v"),
        i(3),
        x = l(l.POSTFIX_MATCH),
      }
    )
  ),
  -- ++ and --
  postfix({
    trig = "++",
    desc = "x = x + 1",
    disabled_prefix = true,
  }, {
    l(l.POSTFIX_MATCH),
    t(" = "),
    l(l.POSTFIX_MATCH),
    t(" + 1"),
  }),
  postfix({
    trig = "--",
    desc = "x = x - 1",
    disabled_prefix = true,
  }, {
    l(l.POSTFIX_MATCH),
    t(" = "),
    l(l.POSTFIX_MATCH),
    t(" - 1"),
  }),
}
