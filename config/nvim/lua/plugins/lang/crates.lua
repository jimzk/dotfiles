return {
  "saecki/crates.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  ft = { "toml" },
  init = function()
    -- https://github.com/Saecki/crates.nvim#nvim-cmp-source
    vim.api.nvim_create_autocmd("BufRead", {
      group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
      pattern = "Cargo.toml",
      callback = function(options)
        require("cmp").setup.buffer({
          sources = {
            { name = "crates" },
            { name = "nvim_lsp" },
            { name = "path" },
          },
        })
        local bufnr = options.buf
        require("which-key").register({
          name = "Cargo.toml"
        }, { prefix = "<leader>cc", buffer = bufnr })
        local opts = { buffer = bufnr }
        map("n", "<leader>cct", [[<cmd>lua require('crates').toggle()<cr>]],
          "toggle virtual text and diagnostics", opts)
        -- Info
        map("n", "<leader>cci", [[<cmd>lua require('crates').show_popup()<cr>]],
          "show info on cursor", opts)
        map("n", "<leader>ccI",
          [[<cmd>lua require('crates').show_popup()<cr><cmd>lua require('crates').focus_popup()<cr>]],
          "show info on cursor and focus", opts)
        -- Upgrade
        map("n", "<leader>ccu", [[<cmd>lua require('crates').upgrade_crate()<cr>]],
          "update crate on current line", opts)
        map("n", "<leader>ccU", [[<cmd>lua require('crates').upgrade_all_crates()<cr>]],
          "update all crate", opts)
        -- Open
        map("n", "<leader>cco", [[<cmd>lua require('crates').open_crates_io()<cr>]],
          "open crate page on current line", opts)
        map("n", "<leader>cch", [[<cmd>lua require('crates').open_homepage()<cr>]],
          "open home page on current line", opts)
        map("n", "<leader>ccr", [[<cmd>lua require('crates').open_repository()<cr>]],
          "open repository page on current line", opts)
        map("n", "<leader>ccd", [[<cmd>lua require('crates').open_documentation()<cr>]],
          "open documentation page on current line", opts)
      end,
    })
  end,
  -- crates load at insert
  opts = {
    null_ls = {
      enabled = true,
      name = "crates.nvim",
    },
  },
}
