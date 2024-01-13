local M = {
  "kylechui/nvim-surround",
  event = "VeryLazy",
  dependencies = {
    "echasnovski/mini.surround",
    enabled = false,
  },
}

M.init = function()
  require("which-key").register({
    ["s"] = {
      name = "+surrounding",
      a = { mode = { "n", "x" }, desc = "Surrounding Add" },
      A = { mode = { "n", "x" }, desc = "Surrounding Add in New Line" },
      d = { desc = "Surrounding Delete" },
      r = { desc = "Surrounding Replace" },
      R = { desc = "Surrounding Replace in New Line" },
    },
  })
end

M.keys = {
  { mode = "v", "sq", "sqq", remap = true },
  { "s<BS>", "sdd", remap = true, desc = "Surrounding Delete Quick (sdd)" },
  { "s<space>", "srr", remap = true, desc = "Surrounding Change Quick (srr)" },
}

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
