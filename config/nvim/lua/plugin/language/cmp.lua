
-- Set up nvim-cmp.
vim.cmd("set completeopt=menu,menuone,noselect")
local cmp = require("cmp")

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

local _format = require('lspkind').cmp_format({
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

local _mapping_tab = function(fallback)
  if cmp.visible() then
    -- cmp.select_next_item()
    cmp.confirm({ select = true })
  elseif require("luasnip").expand_or_jumpable() then
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
  else
    fallback()
  end
end

local _mapping_s_tab = function(fallback)
  if cmp.visible() then
    -- cmp.select_prev_item()
    cmp.abort()
  elseif require("luasnip").jumpable(-1) then
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
  else
    fallback()
  end
end

local _mapping = {
  ["<C-p>"] = cmp.mapping.select_prev_item(),
  ["<C-n>"] = cmp.mapping.select_next_item(),
  ["<C-k>"] = cmp.mapping.select_prev_item({count = 20}),  -- page up
  ["<C-j>"] = cmp.mapping.select_next_item({count = 20}),  -- page down
  ['<M-u>'] = cmp.mapping.scroll_docs(-4),
  ['<M-d>'] = cmp.mapping.scroll_docs(4),
  ['<C-d>'] = cmp.mapping.abort(),
  ['<C-Space>'] = cmp.mapping.confirm({ select = true }),
  ['<CR>'] = cmp.mapping.confirm({ select = true }),
  -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#super-tab-like-mapping
  -- https://github.com/NvChad/NvChad/blob/main/lua/plugins/configs/cmp.lua#L66
  ["<Tab>"] = cmp.mapping(_mapping_tab, {"i", "s"}),
  ["<S-Tab>"] = cmp.mapping(_mapping_s_tab, {"i", "s"}),
}

local _mapping_cmdline = {
  ['<C-d>'] = { c = _mapping['<C-d>'] },
  ['<C-Space>'] = { c = _mapping['<C-Space>'] },
  -- ['<CR>'] = { c = _mapping['<CR>'] },
  ['<Tab>'] = { c = _mapping_tab },
  ['<S-Tab>'] = { c = _mapping_s_tab }
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
    format = _format
  },
  mapping = cmp.mapping.preset.insert(_mapping),
  sources = cmp.config.sources(
    -- Each outer {..} is a source group, and cmp uses the first group (in order) with avaliable items and hide others.
    {
      { name = 'nvim_lsp' },
      { name = 'luasnip' , option = {show_autosnippets = true}},
    },
    {
      { name = 'buffer' },
      { name = "path"},
      { name = 'calc'}
    }
  )
})

cmp.setup.filetype('gitcommit', {
  mapping = cmp.mapping.preset.insert(_mapping),
  sources = cmp.config.sources(
    {
      { name = 'git' },  -- Trigger: : for commits
    },
    {
      { name = 'buffer' },
    }
  )
})

cmp.setup.cmdline({ '/', '?' }, {
  -- https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/mapping.lua#L61
  mapping = cmp.mapping.preset.cmdline(_mapping_cmdline),
  sources = {
    { name = 'nvim_lsp_document_symbol' },  -- Trigger: /@
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(_mapping_cmdline),
  sources = cmp.config.sources(
    {
      { name = 'path' }
    },
    {
      { name = 'cmdline' }
    }
  )
})
