local M = {
  "Saecki/crates.nvim",
  event = { "BufRead Cargo.toml" },
}

-- crates load at insert
M.opts = {
  lsp = {
    enabled = true,
    actions = true,
    completion = true,
    hover = true,
  },
  completion = {
    cmp = { enabled = true },
  },
  popup = {
    autofocus = true,
  },
}

M.config = function(_, opts)
  require("crates").setup(opts)

  vim.api.nvim_create_autocmd("BufRead", {
    group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
    pattern = "Cargo.toml",
    callback = function(options)
      local bufnr = options.buf
      require("which-key").register({ name = "+Cargo.toml" }, { prefix = "<leader>cc", buffer = bufnr })
      local crates = require("crates")
      local opts = { buffer = options.buf }
      local map = Util.map
      map("n", "<leader>cct", crates.toggle, "Toggle Virtual Text and Diagnostics", opts)
      -- Info
      map("n", "<leader>cci", crates.show_crate_popup, "Show Crate Detail", opts)
      map("n", "<leader>ccl", crates.show_dependencies_popup, "List Crates", opts)
      -- Edit Dependency
      map("n", "<leader>ccv", crates.show_versions_popup, "Edit Crate Version", opts)
      map("n", "<leader>ccf", crates.show_features_popup, "Edit Crate Features", opts)
      map("n", "<leader>cce", crates.expand_plain_crate_to_inline_table, "Expand Plain Crate to Inline Table", opts)
      map("n", "<leader>ccE", crates.extract_crate_into_table, "Extract Crate Declaration Into a TOML Section", opts)
      -- Upgrade/Update
      map("n", "<leader>ccg", crates.upgrade_crate, "Upgrade Crate", opts)
      map("x", "<leader>ccg", crates.upgrade_crates, "Upgrade Selected Crates", opts)
      map("n", "<leader>ccg", crates.upgrade_all_crates, "Upgrade All Crates", opts)
      map("n", "<leader>ccu", crates.update_crate, "Update Crate (minor version)", opts)
      map("x", "<leader>ccu", crates.update_crates, "Update Selected Crates (minor version)", opts)
      map("n", "<leader>ccU", crates.update_all_crates, "Update All Crates (minor version)", opts)
      -- Open
      map("n", "<leader>cc1", crates.open_crates_io, "Open Crate Page", opts)
      map("n", "<leader>cc2", crates.open_homepage, "Open Crate Home Page", opts)
      map("n", "<leader>cc3", crates.open_repository, "Open Crate Repository", opts)
      map("n", "<leader>cc4", crates.open_documentation, "Open Crate Documentation", opts)
    end,
  })
end

return M
