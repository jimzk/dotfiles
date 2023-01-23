return {
  "phaazon/mind.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>m", "<cmd>MindOpenMain<cr>", desc = "open notes (mind)" },
  },
  opts = {
    keymaps = {
      normal = {
        -- o = "open_data_index",
        -- O = function() end,
        -- a = "add_below",
        -- A = "add_above",
      },
    },
  },
  config = function(_, opts)
    require("mind").setup(opts)
    vim.cmd([[autocmd FileType mind map <buffer> ? :h mind-config-keymaps<cr>]])
  end,
}
