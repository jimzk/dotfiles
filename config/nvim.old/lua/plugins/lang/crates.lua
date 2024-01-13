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
        map("n", "<leader>cct", function() require("crates").toggle() end, "toggle virtual text and diagnostics", opts)
        -- Info
        map("n", "<leader>cci", function() require("crates").show_crate_popup() end,
          "show crate details", opts)
        map("n", "<leader>ccl", function() require("crates").show_dependencies_popup() end,
          "show crates list", opts)
        -- Edit Dependency
        map("n", "<leader>ccv", function() require("crates").show_versions_popup() end,
          "edit crate version", opts)
        map("n", "<leader>ccf", function() require("crates").show_features_popup() end,
          "edit crate features", opts)
        map("n", "<leader>cce", function() require("crates").expand_plain_crate_to_inline_table() end,
          "expand plain crate to inline table", opts)
        map("n", "<leader>ccE", function() require("crates").extract_crate_into_table() end,
          "extract crate declaration into a TOML section", opts)
        -- Upgrade/Update
        map("n", "<leader>ccg", function() require("crates").upgrade_crate() end,
          "upgrade crate", opts)
        map("x", "<leader>ccg", function() require("crates").upgrade_crates() end,
          "upgrade selected crates", opts)
        map("n", "<leader>ccg", function() require("crates").upgrade_all_crates() end,
          "upgrade all crates", opts)
        map("n", "<leader>ccu", function() require("crates").update_crate() end,
          "update crate (minor version)", opts)
        map("x", "<leader>ccu", function() require("crates").update_crates() end,
          "update selected crates (minor version)", opts)
        map("n", "<leader>ccU", function() require("crates").update_all_crates() end,
          "update all crates (minor version)", opts)
        -- Open
        map("n", "<leader>cc1", function() require("crates").open_crates_io() end,
          "open crate page", opts)
        map("n", "<leader>cc2", function() require("crates").open_homepage() end,
          "open crate home page", opts)
        map("n", "<leader>cc3", function() require("crates").open_repository() end,
          "open crate repository", opts)
        map("n", "<leader>cc4", function() require("crates").open_documentation() end,
          "open crate documentation", opts)
      end,
    })
  end,
  -- crates load at insert
  opts = {
    null_ls = {
      enabled = true,
      name = "crates.nvim",
    },
    popup = {
      autofocus = true,
    }
  },
}
