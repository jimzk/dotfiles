local ls = require("luasnip")
local t = ls.text_node
local i = ls.insert_node
local n = require("luasnip.extras").nonempty
local l = require("luasnip.extras").lambda
local fmt = require("luasnip.extras.fmt").fmt
local ts_postfix = require("luasnip.extras.treesitter_postfix").treesitter_postfix

return {
  ts_postfix(
    {
      trig = "var",
      matchTSNode = {
        query = [[
            (function_declaration
              name: (identifier) @fname
              parameters: (parameters) @params
              body: (block) @body
            ) @prefix
        ]],
        query_lang = "lua",
      },
    },
    fmt(
      [[
    local {} = function{}
        {}
    end
]],
      {
        l(l.LS_TSCAPTURE_FNAME),
        l(l.LS_TSCAPTURE_PARAMS),
        l(l.LS_TSCAPTURE_BODY),
      }
    ),
    {
      show_condition = function(line_to_cursor)
        local prefix = string.sub(line_to_cursor, 1, -3)
        return prefix:sub(-3) == "end"
      end,
    }
  ),
}
