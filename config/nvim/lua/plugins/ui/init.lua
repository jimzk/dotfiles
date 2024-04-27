local specs = Util.load_specs("ui")

vim.list_extend(specs, {
  { "folke/noice.nvim", enabled = false },

  -- Colorscheme
  -- Override:
  -- https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/plugins/colorscheme.lua#L11
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      -- latte, frappe, macchiato, mocha
      flavour = "frappe",
      -- transparent_background = true, -- disables setting the background color.
      term_colors = true, -- for neovide
      styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" },
        -- functions = { "bold" },
        -- types = { "bold" },
      },
      custom_highlights = { --  or use function(colors) and return a table
        WinSeparator = { fg = "#404556" },
        -- Brighter highlight
        -- LineNr = { fg = "#5c637c" },
        -- Visual = { fg = "#e5e6ec", bg = "#505775" }, -- Remove bold
        CursorLineNr = { fg = "#FFD400", style = { "bold" } }, -- #CFD0F5
        -- CursorLineNr = { style = { "bold" }, fg = "#303447" },
        CursorLine = { bg = "#555555" }, -- #4E5264
        Visual = { bg = "#555555", style = {} },
      },
      dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = "light",
        percentage = 0.9, -- percentage of the shade to apply to the inactive window
      },
      integrations = {
        harpoon = true,
      },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      -- The default is tokyonight
      colorscheme = "catppuccin",
    },
  },
})

return specs
