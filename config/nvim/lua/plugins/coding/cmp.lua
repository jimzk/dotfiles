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

local select_item = function(direction, behavior)
  local cmp = require("cmp")
  local select = (direction == "next") and cmp.select_next_item or cmp.select_prev_item
  behavior = behavior or cmp.SelectBehavior.Insert
  return function(_)
    if cmp.visible() then
      -- No fill insertion when move among selection
      select({ behavior = behavior })
    else
      cmp.complete()
    end
  end
end

local my_mapping = function()
  local cmp = require("cmp")
  local luasnip = require("luasnip")

  local action_tab = function(fallback)
    if cmp.visible() then
      cmp.confirm({ select = false })
    elseif luasnip.expand_or_locally_jumpable() then -- Jumpable is ignored is cursor out of current snippet
      luasnip.expand_or_jump()
    else
      fallback()
    end
  end

  local sources = { "luasnip", "nvim_lsp", "buffer" }
  local cycle_source = function(fallback)
    if cmp.visible() then
      local i = vim.g.cmp_source_index or 1
      i = i < #sources and i + 1 or 1
      vim.g.cmp_source_index = i
      local source = sources[i]
      cmp.complete({ config = { sources = { { name = source } } } })
      vim.notify("cmp source is " .. source, vim.log.levels.INFO, { title = "Cmp" })
    else
      fallback()
    end
  end

  return {
    ["<C-b>"] = cmp.mapping.scroll_docs(-4), -- preview up
    ["<C-f>"] = cmp.mapping.scroll_docs(4), -- preview down
    ["<C-c>"] = cmp.mapping.abort(),
    -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#super-tab-like-mapping
    -- https://github.com/NvChad/NvChad/blob/main/lua/plugins/configs/cmp.lua#L66
    ["<Tab>"] = cmp.mapping(action_tab, { "i", "s" }),

    ["<C-p>"] = cmp.mapping(select_item("prev"), { "i", "s" }),
    ["<C-n>"] = cmp.mapping(select_item("next"), { "i", "s" }),
    -- page up / down
    ["<C-M-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select, count = 20 }),
    ["<C-M-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select, count = 20 }),

    ["<C-,>"] = cmp.mapping(cycle_source, { "i", "s" }),
  }
end

local my_mapping_cmdline = function()
  local cmp = require("cmp")
  return {
    ["<C-p>"] = { c = select_item("prev", cmp.SelectBehavior.Insert) },
    ["<C-n>"] = { c = select_item("next", cmp.SelectBehavior.Insert) },
    ["<C-c>"] = { c = cmp.mapping.abort() },
    ["<Tab>"] = { c = cmp.mapping.confirm({ select = false }) },
    -- ["<CR>"] = { c = cmp.mapping.confirm({ select = true }) },
  }
end

local lsp_ignored_words = {
  "Workspace loading:", -- lua
}
M.config = function()
  local cmp = require("cmp")
  local icons = require("config").icons.kinds
  cmp.setup({
    completion = {
      completeopt = "menu,menuone,noinsert",
    },
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert(my_mapping()),
    sources = cmp.config.sources({
      {
        name = "nvim_lsp",
        entry_filter = function(entry, _)
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
      { name = "buffer", keyword_length = 3 },
      { name = "path" },
    }),
    formatting = {
      format = function(_, item)
        if icons[item.kind] then
          item.kind = icons[item.kind] .. item.kind
        end
        -- https://github.com/hrsh7th/nvim-cmp/discussions/609#discussioncomment-3395522
        if #item.abbr > 30 then
          item.abbr = vim.fn.strcharpart(item.abbr, 0, 30) .. "…"
        end
        return item
      end,
    },
    experimental = {
      ghost_text = {
        hl_group = "LspCodeLens",
      },
    },
  })

  cmp.setup.cmdline({ "/", "?" }, {
    -- https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/mapping.lua#L61
    mapping = cmp.mapping.preset.cmdline(my_mapping_cmdline()),
    sources = {
      { name = "buffer" },
    },
  })

  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(my_mapping_cmdline()),
    sources = {
      { name = "cmdline" },
      { name = "path" },
    },
    formatting = {
      format = function(entry, item)
        if icons[item.kind] then
          -- cmdline returns "Variable" as kind. Format it!
          local kind = entry.source.name == "cmdline" and "Cmd" or item.kind
          item.kind = icons[item.kind] .. kind
        end
        return item
      end,
    },
  })
end

return M
