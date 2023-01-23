local M = {
  "windwp/nvim-autopairs",
  event = "VeryLazy",
}

M.opts = {
  check_ts = true,
  -- ts_config = {
  --   lua = { 'string' }, -- it will not add a pair on that treesitter node
  --   javascript = { 'template_string' },
  --   java = false, -- don't check treesitter on java
  -- },
  -- https://github.com/windwp/nvim-autopairs#FastWrap
  fast_wrap = {
    map = "<M-e>",
    chars = { "{", "[", "(", "<", '"', "'" },
    pattern = [=[[%'%"%)%>%]%)%}%,]]=],
    end_key = "p",
  },
  -- Do not pair when next char is matched
  -- https://github.com/windwp/nvim-autopairs/blob/master/lua/nvim-autopairs/rules/basic.lua#L10
  ignored_next_char = [=[[%w%%%'%[%"%.%(%{%<]]=],
  -- Do not enable autopair in "..." or '...'
  enable_bracket_in_quote = false,
  -- Type closing bracket do not add char but move to right
  enable_moveright = true,
}

M.config = function(_, opts)
  -- Insert `(` after select function or method item
  -- https://github.com/hrsh7th/nvim-cmp/wiki/Advanced-techniques#add-parentheses-after-selecting-function-or-method-item
  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())

  local npairs = require("nvim-autopairs")
  npairs.setup(opts)

  -- https://github.com/windwp/nvim-autopairs#treesitter
  local ts_conds = require("nvim-autopairs.ts-conds")
  local cond = require("nvim-autopairs.conds")

  -- Add <>
  -- Ref: https://github.com/windwp/nvim-autopairs/issues/301#issuecomment-1382215955
  -- Implementation: https://github.com/windwp/nvim-autopairs/blob/master/lua/nvim-autopairs/rules/basic.lua
  local basic = require("nvim-autopairs.rules.basic")
  local utils = require("nvim-autopairs.utils")
  utils.is_close_bracket = (function(func)
    return function(char)
      return func(char) or char == ">"
    end
  end)(utils.is_close_bracket)
  local bracket = basic.bracket_creator(npairs.config)
  npairs.add_rules({
    bracket("<", ">"):with_pair(cond.not_before_text(" ")),
  })

  -- Get Treesitter node:
  -- 1) require('nvim-treesitter.ts_utils').get_node_at_cursor():type()
  -- 2) TSPlaygroundToggle
  -- But results from 1) and 2) may be different. Take 1) for granted as it is the lib used by autopairs.

  -- Tweak from https://github.com/windwp/nvim-autopairs/blob/master/lua/nvim-autopairs/ts-conds.lua#L106
  -- Ref: https://github.com/windwp/nvim-autopairs/pull/231
  local function not_in_comments()
    local nodes = { "string", "source", "comment" } -- Treesitter node name
    return ts_conds.is_in_range(function(params)
      if not params then -- Filetype like json do not have node
        return true
      end
      assert(params.type ~= nil, "ts nodes can't be nil")
      local is_in_table = require("nvim-autopairs.utils").is_in_table(nodes, params.type)
      return not is_in_table
    end, function()
      local cursor = vim.api.nvim_win_get_cursor(0)
      -- Seems nvim_win_get_cursor has offset with require('nvim-treesitter.ts_utils').get_node_at_cursor()
      -- Check TS node of the offset postion
      return { cursor[1] - 1, cursor[2] - 1 }
    end)
  end

  -- Do not autopair in comment, e.g. -- line comment in lua
  -- Remember, do not add a new rule if it exists.
  local start_pairs = { "{", "(", "[", "<", "'", '"', "`" }
  for _, start_pair in ipairs(start_pairs) do
    local rules = npairs.get_rule(start_pair)
    -- " and ' have multiple rules
    -- See https://github.com/windwp/nvim-autopairs/blob/master/lua/nvim-autopairs/rules/basic.lua#L33
    rules = rules.with_move and { rules } or rules
    for _, rule in ipairs(rules) do
      -- :with_pair(ts_conds.is_not_ts_node(nodes)) can't work, it still autopair at the end of comment
      rule:with_pair(not_in_comments())
    end
  end

  --   npairs.get_rule("{"):with_cr(cond.done())
end

return M
