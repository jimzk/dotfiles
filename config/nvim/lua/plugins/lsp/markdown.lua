return {
  "iamcco/markdown-preview.nvim",
  dependencies = {
    -- Remove lint. Annoying.
    {
      "nvimtools/none-ls.nvim",
      opts = function(_, opts)
        local nls = require("null-ls")
        local sources = {}
        for _, v in ipairs(opts.sources) do
          if v ~= nls.builtins.diagnostics.markdownlint then
            table.insert(sources, v)
          end
        end
        opts.sources = sources
      end,
    },
    {
      "mfussenegger/nvim-lint",
      opts = function(_, opts)
        opts.linters_by_ft.markdown = {}
      end,
    },
  },
}
