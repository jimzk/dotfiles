local npairs = require("nvim-autopairs")
local Rule = require('nvim-autopairs.rule')

-- use treesitter to check for pair
-- https://github.com/windwp/nvim-autopairs#treesitter
npairs.setup({
  check_ts = true,
  -- ts_config = {
  --   lua = { 'string' }, -- it will not add a pair on that treesitter node
  --   javascript = { 'template_string' },
  --   java = false, -- don't check treesitter on java
  -- },
  -- https://github.com/windwp/nvim-autopairs#FastWrap
  -- See https://github.com/windwp/nvim-autopairs/blob/master/lua/nvim-autopairs/rules/basic.lua#LL18C8-L18C8
  fast_wrap = {
    map = '<M-e>',
    chars = { '{', '[', '(', '<', '"', "'" },
    pattern = [=[[%'%"%)%>%]%)%}%,]]=],
    end_key = 'p',
  },
  -- Do not enable autopair in "..." or '...'
  enable_bracket_in_quote = false,
  -- Type closing bracket do not add char but move to right
  enable_moveright = true,
})

-- https://github.com/windwp/nvim-autopairs#treesitter
local ts_conds = require('nvim-autopairs.ts-conds')
local cond = require('nvim-autopairs.conds')

-- Add <>. Ref https://github.com/windwp/nvim-autopairs/blob/master/lua/nvim-autopairs/rules/basic.lua
npairs.add_rules({
  Rule("<", ">")
      :use_undo(true)
      :with_move(cond.is_bracket_line_move())
      -- move right if repeating >, ref: https://github.com/windwp/nvim-autopairs/issues/227
      :with_move(function(opts) return opts.char == ">" end)
      :with_pair(cond.not_after_regex("[%w]"))-- don't add pair if the next alphanumeric char
      :with_pair(cond.not_before_text(" ")) -- don't add pair if prev char is whitespace
  ,
})

-- npairs.get_rule("[")
--     :with_pair(cond.not_after_regex("[%w]"))

-- Get Treesitter node:
-- 1) require('nvim-treesitter.ts_utils').get_node_at_cursor():type()
-- 2) TSPlaygroundToggle
-- But results from 1) and 2) may be different. Take 1) for granted as it is the lib used by autopairs.

-- Tweak from https://github.com/windwp/nvim-autopairs/blob/master/lua/nvim-autopairs/ts-conds.lua#L106
-- Ref: https://github.com/windwp/nvim-autopairs/pull/231
local function not_in_comments()
  local nodes = { 'string', 'source', 'comment' } -- Treesitter node name
  return ts_conds.is_in_range(
    function(params)
      assert(params.type ~= nil, "ts nodes can't be nil")
      local is_in_table = require('nvim-autopairs.utils').is_in_table(nodes, params.type)
      return not is_in_table
    end,
    function()
      local cursor = vim.api.nvim_win_get_cursor(0)
      -- Seems nvim_win_get_cursor has offset with require('nvim-treesitter.ts_utils').get_node_at_cursor()
      -- Check TS node of the offset postion
      return { cursor[1] - 1, cursor[2] - 1 }
    end)
end

-- Do not autopair in comment, e.g. -- line comment for lua
-- Remember, do not add a new rule if it exists.
local start_pairs = { "{", '(', '[', "<", "'", '"', "`" }
for _, start_pair in ipairs(start_pairs) do
  local rules = npairs.get_rule(start_pair)
  if rules.with_move ~= nil then
    -- " and ' have multiple rules
    -- See https://github.com/windwp/nvim-autopairs/blob/master/lua/nvim-autopairs/rules/basic.lua#L33
    rules = { rules }
  end
  for _, rule in ipairs(rules) do
    -- :with_pair(ts_conds.is_not_ts_node(nodes)) can't work, it still autopair at the end of comment
    rule:with_pair(not_in_comments())
  end
end
