-- auto completion
local M = {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
  },
}

M.config = function()
  local cmp = require("cmp")
  local mapping = require("plugins.coding.cmp.mapping")
  local format = require("plugins.coding.cmp.format")
  local lsp_ignored_words = {
    "Workspace loading:", -- lua
  }
  cmp.setup {
    completion = {
      completeopt = "menu,menuone", -- I remove noselect
      -- autocomplete = false,
      -- autocomplete = { cmp.TriggerEvent.TextChanged },
    },
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert(mapping.mapping),
    sources = cmp.config.sources({
      {
        name = "nvim_lsp",
        entry_filter = function(entry, _)
          -- Kind enum: https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/types/lsp.lua#L178-L204
          -- if kind is Text, then filter
          if entry:get_kind() == 1 then return false end
          local word = entry:get_word()
          for _, value in ipairs(lsp_ignored_words) do
            if word:find(value, 1, true) then
              return false
            end
          end
          return true
        end,
      },
      { name = "luasnip" },
      { name = "buffer", keyword_length = 4 },
      { name = "path" },
    }),
    window = {
      completion = {
        border = "none",
      },
      documentation = {
        border = "none"
      },
    },
    formatting = {
      format = format.format,
    },
    experimental = {
      -- highlight for inline text shown by cmp.SelectBehavior.Select
      ghost_text = {
        hl_group = "Comment",
        -- hl_group = "LspReferenceText",
      },
    },
  }
  -- Make color consisten
  vim.cmd [[hi Pmenu guibg=none]]

  cmp.setup.cmdline({ "/", "?" }, {
    -- window = { completion = { border = "none", }, },
    completion = {
      autocomplete = {
        cmp.TriggerEvent.InsertEnter,
        cmp.TriggerEvent.TextChanged
      },
    },
    -- https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/mapping.lua#L61
    mapping = cmp.mapping.preset.cmdline(mapping.mapping_cmdline),
    sources = {
      { name = "buffer" },
    },
    formatting = {
      format = format.format_cmdline,
    },
  })

  cmp.setup.cmdline(":", {
    -- window = { completion = { border = "none", }, },
    completion = {
      autocomplete = {
        cmp.TriggerEvent.InsertEnter,
        cmp.TriggerEvent.TextChanged
      },
    },
    mapping = cmp.mapping.preset.cmdline(mapping.mapping_cmdline),
    sources = {
      { name = "cmdline" },
      { name = "path" },
    },
    formatting = {
      format = format.format_cmdline,
    },
  })
  -- vim.cmd [[hi CmpItemAbbrMatch guifg=#c2dfae]]
  -- vim.cmd [[hi CmpItemAbbrMatchFuzzy guifg=#c2dfae]]
  -- vim.cmd [[hi PmenuSel guifg=#c2dfae]]
end

return M
