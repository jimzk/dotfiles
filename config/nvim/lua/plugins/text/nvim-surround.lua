local M = {
  "kylechui/nvim-surround",
  event = "VeryLazy",
}

-- Tips (:h nvim-surround.default_pairs)
--  dss: remove any surrounding
--  ysiwf: surrounded by function call
--    - csf: change function call
--    - dsf: delete function call
--  ysiwi{char1}{char2}: input left and right surrounding
--  ysiwt: HTML tag
M.opts = {
  move_cursor = false,
  keymaps = {
    insert = "<C-g>s",
    insert_line = "<C-g>S",
    normal = "ys",
    normal_cur = "yss",
    normal_line = "yS",
    normal_cur_line = "ySS",
    visual = "S",
    visual_line = "gS",
    delete = "ds",
    change = "cs",
    change_line = "cS",
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
    -- a = false,
    -- r = ">",
    b = { ")", "}", "]" },
    B = "}",
    q = { '"', "'", "`" },
    s = { "}", "]", ")", ">", '"', "'", "`" }, -- for quick add/replace
  },
}

M.config = function(_, opts)
  require("nvim-surround").setup(opts)
  vim.cmd("hi! link NvimSurroundHighlight @text.danger")
end

return M
