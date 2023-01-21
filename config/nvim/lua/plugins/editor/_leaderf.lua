return {
  "Yggdroot/LeaderF",
  build = ":LeaderfInstallCExtension",
  event = "VeryLazy",
  init = function()
    vim.g.Lf_ShortcutF = ""
    vim.g.Lf_ShortcutB = ""
    -- vim.g.Lf_RememberLastSearch = 1
    vim.g.Lf_CacheDirectory = vim.fn.stdpath("data")
    -- vim.g.Lf_WindowPosition = "popup"
    -- vim.g.Lf_PopupHeight = 0.75
    -- vim.g.Lf_PopupPosition = { 12, 0 }
    vim.g.Lf_WindowPosition = "bottom"
    vim.g.Lf_PreviewInPopup = 1
    -- vim.g.Lf_PreviewResult = {
    --   ["File"] = 1,
    -- }
    vim.g.Lf_PreviewHorizontalPosition = "center"
    vim.g.Lf_PreviewPopupWidth = 100
    --  Remap key
    -- :h leaderf-prompt
    -- stylua: ignore
    vim.g.Lf_CommandMap = {
      -- down
      ["<C-j>"] = { "<C-n>" },
      -- up
      ["<C-k>"] = { "<C-p>" },
      -- preview result
      -- ["<C-p>"] = { "<Tab>" },
      -- split
      ["<C-x>"] = { "<C-s>" },
      -- split vertical
      ["<C-]>"] = { "<C-v>" },
      -- paste from clipboard
      ["<C-v>"] = { "<C-y>" },
    }
  end,
}
