-- Indicate where the cursor is
return {
  "DanilaMihailov/beacon.nvim",
  enabled = false,
  event = "VeryLazy",
  config = function()
    vim.g.beacon_size = 50
    vim.g.beacon_shrink = 1
    vim.g.beacon_fade = 1
    vim.g.beacon_timeout = 3000
    vim.cmd([[hi! Beacon guibg=#F977C2]])
    -- vim.cmd([[hi! link Beacon @text.warning]])
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = { "*" },
      callback = function(_)
        vim.defer_fn(function()
          vim.cmd("Beacon")
        end, 0)
      end,
    })
  end,
}
