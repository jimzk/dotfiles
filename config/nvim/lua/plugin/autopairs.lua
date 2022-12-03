local npairs = require("nvim-autopairs")
local Rule = require('nvim-autopairs.rule')

-- use treesitter to check for pair
-- https://github.com/windwp/nvim-autopairs#treesitter
npairs.setup({
  check_ts = true,
  ts_config = {
    lua = { 'string' }, -- it will not add a pair on that treesitter node
    javascript = { 'template_string' },
    java = false, -- don't check treesitter on java
  },
  -- https://github.com/windwp/nvim-autopairs#FastWrap
  fast_wrap = {},
})

-- https://github.com/windwp/nvim-autopairs#treesitter
local ts_conds = require('nvim-autopairs.ts-conds')
-- press % => %% only while inside a comment or string
npairs.add_rules({
  Rule("%", "%", "lua")
      :with_pair(ts_conds.is_ts_node({ 'string', 'comment' })),
  Rule("$", "$", "lua")
      :with_pair(ts_conds.is_not_ts_node({ 'function' }))
})

-- local cond = require('nvim-autopairs.conds')
-- local ignore_openings = { "(", "{", "[", ".", '"', "'", }
-- for _, opening in pairs(ignore_openings) do
--   local rule = npairs.get_rule(opening)
--   if rule.with_pair then
--     rule:with_pair(cond.not_before_text("."))
--   else
--     for _, r in pairs(rule) do
--       r:with_pair(cond.not_before_text("."))
--     end
--   end
-- end
