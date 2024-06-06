return {
  "L3MON4D3/LuaSnip",
  event = "InsertEnter",
  dependencies = {
    {
      "garymjr/nvim-snippets",
      enabled = false,
    },
    {
      "nvim-cmp",
      dependencies = {
        "saadparwaiz1/cmp_luasnip",
      },
      opts = function(_, opts)
        opts.snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        }
        table.insert(opts.sources, { name = "luasnip" })
      end,
    },
  },
  opts = function()
    return {
      update_events = "TextChanged,TextChangedI",
      delete_check_events = "TextChanged",
      enable_autosnippets = true,
      ext_opts = {
        [require("luasnip.util.types").choiceNode] = {
          active = {
            virt_text = { { "choiceNode", "Comment" } },
          },
        },
      },
    }
  end,
  config = function(_, opts)
    require("luasnip").setup(opts)
    -- require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./lua/snippets/vscode" } })
    require("snippets") -- Load my snippets
    -- Fix can't jump to next when using <BS> to delete selection
    Util.map("s", "<BS>", "<BS>i")
  end,
}
