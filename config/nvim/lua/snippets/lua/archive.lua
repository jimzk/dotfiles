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

s(
  "function",
  fmt(
    [[
  function({})
    {}
  end{}
  ]],
    {
      -- c(2, {
      --   util.empty_sn(),
      --   sn(nil, { t("local") }, nil, "local"),
      -- }),
      -- -- i(2, "local"),
      -- d(3, function(args)
      --   if args[1][1] ~= "" then
      --     return sn(nil, {
      --       t(" "),
      --       i(1, "foo"),
      --       t(" = "),
      --     })
      --   else
      --     return sn(nil, { t("") })
      --   end
      -- end, { 2 }),
      i(2),
      i(0),
      i(1),
    }
  )
)

local func = {
  c(2, {
    util.empty_sn(),
    sn(nil, { t("local") }, nil, "local"),
  }),
  -- i(2, "local"),
  d(3, function(args, snip)
    if args[1][1] ~= "" then
      return sn(nil, {
        t(" "),
        i(1, "foo"),
        t(" = "),
      })
    else
      return sn(nil, { t("") })
    end
  end, { 2 }),
  t("function("),
  i(4),
  t({ ")", "\t" }),
  i(0),
  t({ "", "end" }),
  i(1),
}

s(
  { trig = "rq", desc = "require(...)" },
  fmt('{}{}require("{}")', {
    c(2, {
      sn(nil, { t("local") }, nil, "local", true),
    }),
    d(3, function(args)
      if args[1][1] ~= "" then
        return sn(nil, {
          t(" "),
          i(1, "module"),
          t(" = "),
        })
      else
        return sn(nil, { t("") })
      end
    end, { 2 }),
    i(1),
  })
)
