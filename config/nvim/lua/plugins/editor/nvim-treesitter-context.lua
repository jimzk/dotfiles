-- Override:
-- https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/plugins/treesitter.lua#L118
return {
  -- Show function context in first line
  "nvim-treesitter/nvim-treesitter-context",
  keys = function()
    return {
      {
        "<leader>ox",
        function()
          local tsc = require("treesitter-context")
          tsc.toggle()
          require("notify").dismiss({ silent = true, pending = false })
          if LazyVim.inject.get_upvalue(tsc.toggle, "enabled") then
            LazyVim.info("Enable Treesitter Context", { title = "Treesitter" })
          else
            LazyVim.warn("Disable Treesitter Context", { title = "Treesitter" })
          end
        end,
        desc = "Toggle Treesitter Context",
      },
    }
  end,
  config = function(_, opts)
    require("treesitter-context").setup(opts)
    -- set TreesitterContext to Normal's guibg
    vim.schedule(function()
      vim.cmd([[hi! TreesitterContext guibg=none gui=bold]])
      vim.cmd([[hi! link TreesitterContextLineNumber Normal]])
      -- vim.cmd([[hi! TreesitterContextLineNumber guifg=#e78285]])
    end)
  end,
}
