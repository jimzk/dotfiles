-- formatters
return {
  "nvimtools/none-ls.nvim",
  event = "BufReadPost",
  opts = function()
    local null_ls = require("null-ls")
    return {
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
      sources = {
        -- null_ls.builtins.formatting.stylua,
        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.diagnostics.actionlint,
        -- For js/ts/vue/react
        null_ls.builtins.code_actions.eslint_d,
        null_ls.builtins.diagnostics.eslint_d,
        -- null_ls.builtins.formatting.eslint_d,
        null_ls.builtins.formatting.prettierd.with({
          extra_filetypes = {
            -- These things should be installed before formatting solidity:
            -- 1. npm install --save-dev prettier prettier-plugin-solidity
            -- 2. config settings.json following https://github.com/prettier-solidity/prettier-plugin-solidity#vscode
            "solidity",
          },
        }),
      },
    }
  end,
}
