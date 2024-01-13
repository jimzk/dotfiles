-- TODO: update and remove none-ls
return {
  "Saecki/crates.nvim",
  init = function()
    local map = require("util").map
    -- https://github.com/Saecki/crates.nvim#nvim-cmp-source
    vim.api.nvim_create_autocmd("BufRead", {
      group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
      pattern = "Cargo.toml",
      callback = function(options)
        local bufnr = options.buf
        -- stylua: ignore start
        require("which-key").register({ name = "+Cargo.toml" }, { prefix = "<leader>cc", buffer = bufnr })
        local opts = { buffer = bufnr }
        map("n", "<leader>cct", function() require("crates").toggle() end, "Toggle Virtual Text and Diagnostics", opts)
        -- Info
        map("n", "<leader>cci", function() require("crates").show_crate_popup() end, "Show Crate Detail", opts)
        map("n", "<leader>ccl", function() require("crates").show_dependencies_popup() end, "List Crates", opts)
        -- Edit Dependency
        map("n", "<leader>ccv", function() require("crates").show_versions_popup() end, "Edit Crate Version", opts)
        map("n", "<leader>ccf", function() require("crates").show_features_popup() end, "Edit Crate Features", opts)
        map("n", "<leader>cce", function() require("crates").expand_plain_crate_to_inline_table() end,
          "Expand Plain Crate to Inline Table", opts)
        map("n", "<leader>ccE", function() require("crates").extract_crate_into_table() end,
          "Extract Crate Declaration Into a TOML Section", opts)
        -- Upgrade/Update
        map("n", "<leader>ccg", function() require("crates").upgrade_crate() end, "Upgrade Crate", opts)
        map("x", "<leader>ccg", function() require("crates").upgrade_crates() end, "Upgrade Selected Crates", opts)
        map("n", "<leader>ccg", function() require("crates").upgrade_all_crates() end, "Upgrade All Crates", opts)
        map("n", "<leader>ccu", function() require("crates").update_crate() end, "Update Crate (minor version)", opts)
        map("x", "<leader>ccu", function() require("crates").update_crates() end,
          "Update Selected Crates (minor version)", opts)
        map("n", "<leader>ccU", function() require("crates").update_all_crates() end, "Update All Crates (minor version)",
          opts)
        -- Open
        map("n", "<leader>cc1", function() require("crates").open_crates_io() end, "Open Crate Page", opts)
        map("n", "<leader>cc2", function() require("crates").open_homepage() end, "Open Crate Home Page", opts)
        map("n", "<leader>cc3", function() require("crates").open_repository() end, "Open Crate Repository", opts)
        map("n", "<leader>cc4", function() require("crates").open_documentation() end, "Open Crate Documentation", opts)
      end,
    })
  end,
  -- crates load at insert
  opts = {
    lsp = {
      enabled = true,
      actions = true,
      completion = true,
      hover = true,
    },
    src = {
      cmp = {
        enabled = true,
      },
    },
    popup = {
      autofocus = true,
    },
  },
}
