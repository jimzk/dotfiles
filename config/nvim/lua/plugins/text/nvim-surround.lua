return {
  -- Has many fancy features, but it always fails to work, like replace/delete pairs.
  "kylechui/nvim-surround",
  event = "VeryLazy",
  -- keys = { "cs", "ds", "ys", { "Y", mode = { "x" } } },
  --
  -- :h nvim-surround.config.keymaps
  -- Tip:
  --  ysiwf: surrounded by function
  --  ysiwi{char1}{char2}: input left and right surrounds
  opts = {
    keymaps = {
      insert = false,
      insert_line = false,
      visual = "x",
      visual_line = "X",
      -- add surrounds by s
      -- normal = "sa",
      -- normal_cur = "saa", -- line
      -- normal_line = "sA", -- line with break
      -- normal_cur_line = "sAA",
      -- visual = "sa",
      -- visual_line = "sA",
      -- delete = "sd",
      -- change = "sr",
    },
    -- alia   add    remove/replace
    -- k      <>     <>
    -- r      []     []
    -- b      ()     (), {}
    -- B      {}     {}
    -- q      ""     "", '', ``
    -- s             any brackets or quotes
    -- See :h nvim-surround.aliasing
    --     :h nvim-surround.config.aliases
    --
    -- key to add brackets (ys)
    surrounds = {
      k = {
        add = { "<", ">" },
      },
      r = {
        add = { "[", "]" },
      },
      b = {
        add = { "(", ")" },
      },
      B = {
        add = { "{", "}" },
      },
      q = {
        add = { '"', '"' },
      },
      Q = {
        add = { "'", "'" },
      },
    },
    aliases = {
      a = false, -- remove default alias
      r = { "]" },
      k = { ">" },
      b = { "}", ")" },
      B = { "}" },
      q = { '"', "'", "`" },
    },
    move_cursor = false,
  },
}
