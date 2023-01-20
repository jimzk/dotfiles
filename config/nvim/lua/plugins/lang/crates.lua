return {
  "saecki/crates.nvim",
  dependencies = { 'nvim-lua/plenary.nvim' },
  ft = { "toml" },
  init = function()
    -- https://github.com/Saecki/crates.nvim#nvim-cmp-source
    vim.api.nvim_create_autocmd("BufRead", {
      group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
      pattern = "Cargo.toml",
      callback = function()
        require("cmp").setup.buffer({
          sources = {
            { name = "crates" },
            { name = "nvim_lsp" },
            { name = "path" },
          },
        })
      end,
    })
  end,
  opts = {
    null_ls = {
      enabled = true,
      name = "crates.nvim",
    },
  },
}
