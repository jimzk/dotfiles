return {
  "carbon-steel/detour.nvim",
  enabled = true,
  keys = {
    { "<C-w><Enter>", "<CMD>DetourCurrentWindow<CR>", desc = "Popup Current File (Detour)" },
    -- { "<C-Enter>", "<CMD>DetourCurrentWindow<CR>", desc = "Popup Current File (Detour)" },
    { "<C-w><C-Enter>", "<CMD>Detour<CR>", desc = "Popup Maximize (Detour)" },
  },
  config = function() end,
}
