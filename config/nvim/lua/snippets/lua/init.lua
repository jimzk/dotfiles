-- https://github.com/L3MON4D3/LuaSnip
local ls = require('luasnip')

ls.add_snippets("all", require("snippets.lua.surrounding"))

--[[
-- Example collections
local s = ls.snippet
local t = ls.text_node
local c = ls.choice_node
set('i', '<c-l>', function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { desc = 'Luasnip: Cycle through choice nodes', })
ls.add_snippets("all", {
  s("choice", { c(1, { t "choice 1", t "choice 2", t "choice 3" }) }),
})
--]]
