return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && yarn install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
  ft = { "markdown" },
  dependencies = {
    -- Remove lint. Annoying.
    {
      "mfussenegger/nvim-lint",
      opts = function(_, opts)
        opts.linters_by_ft.markdown = {}
      end,
    },
  },
}
