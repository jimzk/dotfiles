-- formatters
return {
  "jose-elias-alvarez/null-ls.nvim",
  event = "BufReadPost",
  opts = function()
    local nls = require("null-ls")
    return {
      sources = {
        -- nls.builtins.formatting.prettierd,
        nls.builtins.formatting.stylua,
      },
    }
  end,
}
