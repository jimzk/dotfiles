vim.cmd("set completeopt=menu,menuone,noselect")
local cmp = require("cmp")
local luasnip = require("luasnip")

local function border(hl_name)
  return {
    { "╭", hl_name },
    { "─", hl_name },
    { "╮", hl_name },
    { "│", hl_name },
    { "╯", hl_name },
    { "─", hl_name },
    { "╰", hl_name },
    { "│", hl_name },
  }
end

local format = require('lspkind').cmp_format({
  mode = 'symbol_text', -- show symbol annotations and text
  maxwidth = 80, -- prevent the popup from showing more than 80 characters
  ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
  -- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#basic-customisations
  menu = ({
    buffer = "[Buffer]",
    cmdline = "[Command]",
    nvim_lsp = "[LSP]",
    luasnip = "[LuaSnip]",
    nvim_lua = "[Lua]",
    latex_symbols = "[Latex]",
    git = "[Git]",
    nvim_lsp_document_symbol = "[Symbol]",
    calc = "[Calc]",
  }),
})

local action_tab = function(fallback)
  if cmp.visible() and not vim.g.is_cmp_aborted then
    cmp.select_next_item()
  elseif luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  else
    fallback()
  end
  vim.g.is_cmp_aborted = false
end

local action_s_tab = function(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
  elseif luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    fallback()
  end
end

vim.g.is_cmp_aborted = false
local action_abort = function(fallback)
  if cmp.visible() then
    vim.g.is_cmp_aborted = true
    cmp.abort()
  else
    vim.g.is_cmp_aborted = false
    cmp.complete()
  end
end

local mapping = {
  ["<C-p>"] = cmp.mapping.select_prev_item(),
  ["<C-n>"] = cmp.mapping.select_next_item(),
  ["<C-k>"] = cmp.mapping.select_prev_item({ count = 20 }), -- page up
  ["<C-j>"] = cmp.mapping.select_next_item({ count = 20 }), -- page down
  ['<C-u>'] = cmp.mapping.scroll_docs(-4),
  ['<C-d>'] = cmp.mapping.scroll_docs(4),
  ['<C-c>'] = cmp.mapping(action_abort, { "i" }),
  ['<CR>'] = cmp.mapping.confirm({ select = true }),
  -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#super-tab-like-mapping
  -- https://github.com/NvChad/NvChad/blob/main/lua/plugins/configs/cmp.lua#L66
  ["<Tab>"] = cmp.mapping(action_tab, { "i", "s" }),
  ["<S-Tab>"] = cmp.mapping(action_s_tab, { "i", "s" }),
}

local mapping_cmdline = {
  ['<C-c>'] = { c = action_abort },
  ['<Tab>'] = { c = cmp.mapping.confirm({ select = true }) },
  -- ['<S-Tab>'] = { c = action_s_tab }
}

-- Configuration for autocompletion plugin cmp
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  -- Window appearance
  -- https://github.com/NvChad/NvChad/blob/main/lua/plugins/configs/cmp.lua#L34
  window = {
    completion = {
      border = border "CmpBorder",
      winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
    },
    documentation = {
      border = border "CmpDocBorder",
    },
  },
  -- Menu appearance
  -- https://github.com/NvChad/NvChad/blob/main/lua/plugins/configs/cmp.lua#L51
  formatting = {
    format = format
  },
  mapping = cmp.mapping.preset.insert(mapping),
  sources = cmp.config.sources(
  -- Each outer {..} is a source group, and cmp uses the first group (in order) with avaliable items and hide others.
    {
      { name = "path" },
      { name = 'calc' },
    },
    {
      { name = 'luasnip', option = { show_autosnippets = false } }, -- disable autosnippets to improve performance
      { name = 'nvim_lsp' },
    },
    {
      { name = 'buffer' },
    }
  )
})

cmp.setup.filetype('gitcommit', {
  mapping = cmp.mapping.preset.insert(mapping),
  sources = cmp.config.sources(
    {
      { name = 'git' }, -- Show commits with trigger :
    },
    {
      { name = 'buffer' },
    }
  )
})

cmp.setup.cmdline({ '/', '?' }, {
  -- https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/mapping.lua#L61
  mapping = cmp.mapping.preset.cmdline(mapping_cmdline),
  sources = {
    { name = 'nvim_lsp_document_symbol' }, -- Trigger: /@
    { name = 'buffer', max_item_count = 10 }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(mapping_cmdline),
  sources = cmp.config.sources(
    {
      { name = 'path' }
    },
    {
      { name = 'cmdline' }
    }
  )
})
