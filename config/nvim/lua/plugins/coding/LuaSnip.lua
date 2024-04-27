-- Override:
-- https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/plugins/coding.lua#L5
return {
  "L3MON4D3/LuaSnip",
  -- https://www.lazyvim.org/configuration/recipes#supertab
  event = "InsertEnter",
  dependencies = {
    {
      "rafamadriz/friendly-snippets",
      enabled = false,
      -- config = function()
      --   require("luasnip.loaders.from_vscode").lazy_load({
      --     -- I maintain my own snippets for these languages
      --     exclude = {
      --       "all",
      --       "rust",
      --       "lua",
      --     },
      --   })
      -- end,
    },
  },
  keys = function()
    return {}
  end,
  opts = {
    update_events = "TextChanged,TextChangedI",
    delete_check_events = "TextChanged",
    ext_opts = {
      [require("luasnip.util.types").choiceNode] = {
        active = {
          virt_text = { { "choiceNode", "Comment" } },
        },
      },
    },
  },

  config = function(_, opts)
    require("luasnip").setup(opts)
    -- require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./lua/snippets/vscode" } })
    require("snippets")
    -- Fix can't jump to next when using <BS> to delete selection
    Util.map("s", "<BS>", "<BS>i")
  end,
}
