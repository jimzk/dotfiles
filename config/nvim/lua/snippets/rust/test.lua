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

local util = require("snippets.util")

return {
  s(
    {
      trig = "mod tests",
      desc = "mod tests",
    },
    fmt(
      [[
    #[cfg(test)]
    mod tests {{
        #[test]
        fn {}(){}{} {{
            {}
            Ok(())
        }}
    }}
    ]],
      {
        i(1, "foo"),
        n(2, " -> "),
        i(2, "anyhow::Result<()>"), -- return type
        i(0),
      }
    ),
    { condition = conds_expand.line_begin }
  ),
  s(
    {
      trig = "fn test",
      desc = "fn test()",
    },
    fmt(
      [[
  #[test]
  fn {}(){}{} {{
      {}
      Ok(())
  }}
  ]],
      {
        i(1, "test_foo"),
        n(2, " -> "),
        i(2, "anyhow::Result<()>"), -- return type
        i(0),
      }
    ),
    { condition = conds_expand.line_begin }
  ),
}
