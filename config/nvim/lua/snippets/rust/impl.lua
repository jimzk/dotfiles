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

local default = sn(
  nil,
  fmt(
    [[
  Default for {} {{
      fn default() -> Self {{
          Self {{
              {}
              foo: Default::default()
          }}
      }}
  }}
  ]],
    {
      i(1, "Type"),
      i(2, "todo!()"),
    }
  ),
  nil,
  "Default"
)

local display = sn(
  nil,
  fmt(
    [[
  fmt::Display for {} {{
      fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {{
          // write!(f, "({{}}, {{}})", self.x, self.y),
          {}
      }}
  }}
  ]],
    {
      i(1, "Type"),
      i(3, "todo!()"),
    }
  ),
  nil,
  "Display"
)

local from = sn(
  nil,
  fmt(
    [[
  From<{}> for {} {{
      fn from(value: {}) -> Self {{
          {}
      }}
  }}
  ]],
    {
      i(1, "FromType"),
      i(2, "ToType"),
      rep(1),
      i(3, "todo!()"),
    }
  ),
  nil,
  "From<T>"
)

local try_from = sn(
  nil,
  fmt(
    [[
  TryFrom<{}> for {} {{
      type Error = {};
      fn try_from(value: {}) -> Result<Self, Self::Error> {{
          {}
      }}
  }}
  ]],
    {
      i(1, "FromType"),
      i(2, "ToType"),
      i(3, "Error"),
      rep(1),
      i(4, "todo!()"),
    }
  ),
  nil,
  "TryFrom<T>"
)

local from_str = sn(
  nil,
  fmt(
    [[
  FromStr for {} {{
      type Err = {};
      fn from_str(s: &str) -> Result<Self, Self::Error> {{
          {}
      }}
  }}
  ]],
    {
      i(1, "Type"),
      i(2, "Error"),
      i(3, "todo!()"),
    }
  ),
  nil,
  "FromStr"
)

local to_string = sn(
  nil,
  fmt(
    [[
  ToString for {} {{
      fn to_string(&self) -> String {{
          // write!(f, "({{}}, {{}})", self.x, self.y),
          {}
      }}
  }}
  ]],
    {
      i(1, "Type"),
      i(2, "todo!()"),
    }
  ),
  nil,
  "ToString"
)

local serialize = sn(
  nil,
  fmt(
    [[
  Serialize for {} {{
      fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
      where
          S: serde::Serializer,
      {{
          {}
      }}
  }}
  ]],
    {
      i(1, "Type"),
      i(2, "todo!()"),
    }
  ),
  nil,
  "Serialize"
)

local deserialize = sn(
  nil,
  fmt(
    [[
  <'de> Deserialize<'de> for {} {{
      fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
      where
          D: serde::Deserializer<'de>
      {{
          {}
      }}
  }}
  ]],
    {
      i(1, "Type"),
      i(2, "todo!()"),
    }
  ),
  nil,
  "Desrialize"
)

return {
  s("impl ?", {
    t("impl"),
    f(function(args) -- cut space if it is generics impl
      return args[1][1]:sub(1, 1) == "<" and "" or " "
    end, { 1 }),
    c(1, {
      from,
      try_from,
      from_str,
      to_string,
      default,
      display,
      serialize,
      deserialize,
    }),
  }, { condition = conds_expand.line_begin }),
}
