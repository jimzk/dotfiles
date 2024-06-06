-- NOTE: Experimental. compare it with SmoothCursor
return {
  -- Smooth scroll
  "karb94/neoscroll.nvim",
  enabled = false,
  opts = {
    mappings = {
      "<C-u>",
      "<C-d>",
      "<C-y>",
      "<C-e>",
      "zt",
      "zz",
      "zb",
    },
  },
  config = function(_, opts)
    require("neoscroll").setup(opts)
    require("neoscroll.config").set_mappings({
      ["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "130" } },
      ["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "130" } },
      ["z<CR>"] = { "zt", { "250" } },
    })
  end,
}
