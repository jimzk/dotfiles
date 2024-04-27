local M = {}

local ls = require("luasnip")
local i = ls.insert_node
local t = ls.text_node
local sn = ls.snippet_node
local c = ls.choice_node
local _c = ls._choice_node
local f = ls.function_node
local n = require("luasnip.extras").nonempty

M.empty_sn = function(docstring)
  return sn(nil, { t("") }, nil, docstring and docstring or "~")
end

local RUST = {}

RUST.body = function(pos, without_todo)
  return t({ "{", "\t" }),
    i(pos), -- Body
    without_todo and t({ "", "}" }) or t({ "", "\ttodo!();", "}" })
end

RUST.modifier = function(jump_index)
  return _c(jump_index, { -- modifier
    -- M.empty_sn(),
    t("pub"),
    t("pub(crate)"),
    t("pub(super)"),
  }),
    n(jump_index, " ")
end

M.rust = RUST

local LUA = {}
LUA.body = function(pos)
  return t({ "{", "\t" }),
    i(pos), -- Body
    t({ "", "}" })
end
M.lua = LUA

return M
