return {
  -- https://www.reddit.com/r/neovim/comments/185wem5/spell_check/
  "stevearc/conform.nvim",
  event = "BufReadPost",
  keys = {
    {
      "<F12>",
      -- require("conform").will_fallback_lsp() checks whether the current buffer is formatted by lsp
      function() require("conform").format({ lsp_fallback = true }) end,
      mode = { "n", "v" },
      desc = "format",
    },
    {
      "<leader><F12>",
      function()
        local lazy_util = require("lazy.core.util")
        vim.ui.select({ "[Global]", "[Buffer]" }, {
          prompt = "Toggle Autoformat",
        }, function(choice)
          if not choice then return end
          if choice == "[Global]" then
            vim.g.autoformat = not vim.g.autoformat
            if vim.g.autoformat then
              lazy_util.info("Enabled format on save", { title = "Format" })
            else
              lazy_util.warn("Disabled format on save", { title = "Format" })
            end
          end
          if choice == "[Buffer]" then
            local bufnr = vim.fn.bufnr()
            vim.b[bufnr].autoformat = not vim.b[bufnr].autoformat
            if not vim.b[bufnr].autoformat then
              lazy_util.info("Enabled format for buffer " .. tostring(bufnr) .. " on save", { title = "Format" })
            else
              lazy_util.warn("Disabled format for buffer " .. tostring(bufnr) .. " on save", { title = "Format" })
            end
          end
        end)
      end,
      desc = "Toggle autoformat",
    },
  },
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        python = { "isort", "black" },
        -- Use a sub-list to run only the first available formatter
        javascript = { { "biome", "prettierd", "prettier" } },
        json = { { "jq", "prettierd", "prettier" } },
        sh = { "shfmt" },
        rust = { "rustfmt" },
        toml = { "taplo" },
        yaml = { "yamlfix" },
        markdown = { "injected" },
        -- Remove typoes and codespell as they always makes miscorrection.
        ["*"] = { "trim_whitespace" },
      },
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if not vim.g.autoformat and not vim.b[bufnr].autoformat then return end
        return { timeout_ms = 500, lsp_fallback = true }
      end,
    })
  end,
}
