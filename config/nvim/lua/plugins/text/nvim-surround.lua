local M = {
  "kylechui/nvim-surround",
  event = "VeryLazy",
  dependencies = {
    "echasnovski/mini.surround",
    enabled = false,
  },
}

M.init = function()
  WhichKey.register({
    ["s"] = {
      name = "+surrounding",
      a = { mode = { "n", "x" }, desc = "Bracket Add" },
      A = { mode = { "n", "x" }, desc = "Bracket Add in New Line" },
      d = { desc = "Bracket Delete" },
      r = { desc = "Bracket Replace" },
      R = { desc = "Bracket Replace in New Line" },
    },
  })
end

M.keys = function()
  local M = {
    -- { "s<BS>", "sdd", remap = true, desc = "Bracket Delete Quick (sdd)" },
    -- { "s<space>", "srr", remap = true, desc = "Bracket Change Quick (srr)" },
  }

  local add_bracket_alias = function(alias, open, close)
    table.insert(M, {
      mode = "x",
      "s" .. alias,
      "sa" .. alias,
      remap = true,
      desc = "Add " .. open .. ".." .. close,
    })
  end

  add_bracket_alias("q", '"', '"')
  add_bracket_alias("'", "'", "'")
  add_bracket_alias('"', "'", "'")
  add_bracket_alias("`", "`", "`")
  add_bracket_alias("(", "( ", " )")
  add_bracket_alias("{", "{ ", " }")
  add_bracket_alias("[", "[ ", " ]")
  add_bracket_alias("<", "< ", " >")
  add_bracket_alias(")", "(", ")")
  add_bracket_alias("}", "{", "}")
  add_bracket_alias("]", "[", "]")
  add_bracket_alias(">", "<", ">")
  add_bracket_alias("f", "fn(", ")")

  return M
end

-- Extra Tips (:h nvim-surround.default_pairs)
--  sdd: remove any surrounding
--  saiwf: surrounded by function call
--    - csf: change function call
--    - dsf: delete function call
--  saiwi{char1}{char2}: input left and right surrounding
--  saiwt: HTML tag
M.opts = {
  move_cursor = false,
  keymaps = {
    insert = false,
    insert_line = false,
    normal = "sa",
    normal_cur = "saa",
    normal_line = "sA",
    normal_cur_line = "sAA",
    visual = "sa",
    visual_line = "sA",
    delete = "sd",
    change = "sr",
    change_line = "sR",
  },
  -- alia   add    remove/replace
  -- r      <>     <>
  -- b      ()     (), {}
  -- B      {}     {}
  -- q      ""     "", '', ``
  -- See :h nvim-surround.aliasing
  --     :h nvim-surround.config.aliases
  --
  -- key to add brackets (ys)
  surrounds = {
    -- r = {
    --   add = { "<", ">" },
    -- },
    b = {
      add = { "(", ")" },
    },
    B = {
      add = { "{", "}" },
    },
    q = {
      add = { '"', '"' },
    },
  },
  -- https://github.com/kylechui/nvim-surround/blob/main/lua/nvim-surround/config.lua
  aliases = {
    a = false,
    s = false,
    -- r = ">",
    b = { ")", "}" },
    B = "}",
    k = ">",
    l = "]",
    q = { '"', "'", "`" },
    d = { "}", "]", ")", ">", '"', "'", "`" }, -- for sdd
    r = { "}", "]", ")", ">", '"', "'", "`" }, -- for srr
  },
}

M.config = function(_, opts)
  require("nvim-surround").setup(opts)
  vim.cmd("hi! link NvimSurroundHighlight @text.danger")
end

return M
