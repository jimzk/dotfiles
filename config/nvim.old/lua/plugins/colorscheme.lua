return {

  -- tokyonight
  -- {
  --   "folke/tokyonight.nvim",
  --   opts = { style = "moon" },
  -- },

  -- catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      -- latte, frappe, macchiato, mocha
      flavour = "frappe",
      transparent_background = true,   -- disables setting the background color.
      term_colors = true,              -- for neovide
      custom_highlights = function(colors)
        return {
          -- brighter highlight (frappe)
          -- CursorLine = { bg = "#464a61" },
          -- CursorLineNr = { fg = "#cfd0f5" },
          -- LineNr = { fg = "#5c637c" },
          WinSeparator = { fg = "#404556" },
          Visual = { style = {}, fg = "#e5e6ec", bg = "#505775" }, -- Remove bold
          CursorLine = { bg = "#4E5264" },
        }
      end,
      -- dim_inactive = {
      --   enabled = true,
      --   shade = "dark",
      --   percentage = 0.05,
      -- },
      integrations = {
        -- aerial = true,
        gitsigns = true,
        fidget = true,
        neotree = true,
        cmp = true,
        mini = true,
        mason = true,
        notify = true,
        treesitter = true,
        telescope = true,
        treesitter_context = true,
        ts_rainbow = true,
        which_key = true,
        illuminate = true,
        lsp_trouble = true,
        harpoon = true,
        barbecue = {
          dim_dirname = true,
        },
        navic = {
          enabled = true
        },
        neogit = true,
        indent_blankline = {
          enabled = true,
          colored_indent_levels = false,
        },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
        },
      },
    },
  },

  {
    "EdenEast/nightfox.nvim",
  },
}
