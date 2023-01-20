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
    vim.g.Lf_CommandMap = {
      ["<C-j>"] = {
        "<C-n>", -- down
      },
      ["<C-k>"] = {
        "<C-p>", -- up
      },
      -- ["<C-p>"] = {
      --   "<Tab>", -- preview result
      -- },
      ["<C-x>"] = {
        "<C-s>", -- split
      },
      ["<C-]>"] = {
        "<C-v>", -- split vertical
      },
      ["<C-v>"] = {
        "<C-y>", -- paste from clipboard
      },
    }
  end,
}
