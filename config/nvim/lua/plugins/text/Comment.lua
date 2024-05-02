return {
  "numToStr/Comment.nvim",
  dependencies = {
    { "echasnovski/mini.comment", enabled = false },
  },
  event = "BufReadPost",
  init = function()
    require("which-key").register({ ["gc"] = { name = "+comment" } })
  end,
  keys = {
    -- need vim-textobj-comment
    { "gcu", "gcic", remap = true, desc = "Uncomment" },
    -- { "gcd", "dax", remap = true, desc = "Delete Comment" },
    { "dgc", "dac", remap = true, desc = "Delete Comment" },
    { "gcv", "gvgc<C-o>", remap = true, desc = "Comment Last Visual" },
    { "gcf", "gcoFIX: ", desc = "Add FIX below", remap = true },
    { "gcF", "gcOFIX: ", desc = "Add FIX above", remap = true },
    { "gct", "gcoTODO: ", desc = "Add TODO below", remap = true },
    { "gcT", "gcOTODO: ", desc = "Add TODO above", remap = true },
  },
  opts = {
    toggler = {
      line = "gcc",
      block = "gCC",
    },
    opleader = {
      line = "gc",
      block = "gC",
    },
    extra = {
      above = "gcO",
      below = "gco",
      eol = "gcA",
    },
    mappings = {
      basic = true,
      extra = true,
    },
    pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
  },
}
