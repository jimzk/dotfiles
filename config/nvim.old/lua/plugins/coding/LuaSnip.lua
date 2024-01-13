return {
  "L3MON4D3/LuaSnip",
  event = "InsertEnter",
  dependencies = {
    "rafamadriz/friendly-snippets",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load {
        -- I maintain my own snippets for these languages
        exclude = {
          "rust"
        }
      }
    end,
  },
  opts = {
    history = true,
    delete_check_events = "TextChanged",
  },
  config = function(_, opts)
    require("luasnip").setup(opts)
    require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./lua/snippets/vscode" } })
    require("snippets.lua")
    -- Fix can't jump to next when using <BS> to delete selection
    map("s", "<BS>", "<BS>i")
  end,
}
