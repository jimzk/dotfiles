return {
  "numToStr/Comment.nvim",
  dependencies = {
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      lazy = true,
      opts = {
        enable_autocmd = false,
      },
    },
  },
  event = "BufReadPost",
  init = function()
    require("which-key").register({ ["gc"] = { name = "+comment" } })
  end,
  keys = {
    -- need vim-textobj-comment
    { "gcu", "gcic", remap = true, desc = "Uncomment" },
    -- { "gcd", "dax", remap = true, desc = "Delete Comment" },
    { "gcd", "dac", remap = true, desc = "Delete Comment" },
    { "gcv", "gvgc<C-o>", remap = true, desc = "Comment Last Visual" },
    { "gcf", "gcoFIX: ", desc = "Add FIX below", remap = true },
    { "gcF", "gcOFIX: ", desc = "Add FIX above", remap = true },
    { "gct", "gcoTODO: ", desc = "Add TODO below", remap = true },
    { "gcT", "gcOTODO: ", desc = "Add TODO above", remap = true },
  },
  config = function(_, opts)
    local opts = {
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
    }
    require("Comment").setup(opts)
  end,
}
