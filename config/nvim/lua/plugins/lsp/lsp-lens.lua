return {
  -- ISSUE:
  -- - definition | implements shown in nvim-treesitter-context. I don't like this.
  -- - It will change view when typing. I don't like this.
  -- - LSP lua_ls has bug. It has two definition
  "VidocqH/lsp-lens.nvim",
  event = "VeryLazy",
  enabled = false,
  keys = {
    { "<leader>ol", "<CMD>LspLensToggle<CR>", "Toggle Definition Info" },
  },
  opts = {},
}
