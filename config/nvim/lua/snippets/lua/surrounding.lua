local ls = require "luasnip"
local f = ls.function_node
local postfix = require "luasnip.extras.postfix".postfix

-- https://zjp-cn.github.io/neovim0.6-blogs/nvim/luasnip/doc1.html#postfix
-- foo[ -> [foo]
local make_postfix = function(opening, closing)
  return postfix({
    trig = ".\\" .. closing,
    dscr = "foo." .. opening .. " -> " .. opening .. "foo" .. closing
  }, {
    f(function(_, parent)
      return opening .. parent.snippet.env.POSTFIX_MATCH .. closing
    end, {}
    ),
  })
end

return {
  -- -- NOTE: [ can't work so I change trigger key from [ to ]
  -- make_postfix("[", "]"),
  -- make_postfix("{", "}"),
  -- make_postfix("(", ")"),
  -- make_postfix("<", ">"),
  -- -- FIX: ' and " can't work
  -- -- https://github.com/hrsh7th/nvim-cmp/issues/1345
  -- make_postfix('"', '"'),
  -- make_postfix("'", "'"),
}
