local specs = require("util").load_specs("lsp")

vim.list_extend(specs, {
  -- Delete buffer without messing up layout
  {
    "williamboman/mason.nvim",
    -- https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/plugins/lsp/init.lua#L206
    keys = {
      { "<leader>cm", false },
      { "<leader>nN", "<cmd>Mason<cr>", desc = "Mason" },
    },
  },
})

-- Temporary remove
for i, spec in ipairs(specs) do
  if spec[1] == "jimzk/rust-tools.nvim" then
    table.remove(specs, i)
  end
end

return specs
