local cmp = require("cmp")
local luasnip = require("luasnip")
vim.o.completeopt = "menu,menuone,noselect"

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

-- Insert `(` after select function or method item
-- https://github.com/hrsh7th/nvim-cmp/wiki/Advanced-techniques#add-parentheses-after-selecting-function-or-method-item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

local lspkind = require('lspkind')
local format = lspkind.cmp_format({
  mode = 'symbol_text', -- show symbol annotations and text
  maxwidth = 40, -- prevent the popup from showing more than 80 characters
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
  -- if cmp.visible() then
  --   cmp.confirm({ select = true })
  if luasnip.expand_or_jump() then
    local _, col = unpack(vim.api.nvim_win_get_cursor(0))
    local next_char = vim.api.nvim_get_current_line():sub(col + 1, col + 1)
    if next_char == " " then luasnip.expand_or_jump() end
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
    cmp.complete({ config = { sources = { { name = sources[i] } } } })
  else
    fallback()
  end
end

local mapping = {
  ["<C-p>"] = cmp.mapping(
    function(_) if cmp.visible() then cmp.select_prev_item() else cmp.complete() end end
    , { "i", "s" }),
  ["<C-n>"] = cmp.mapping(
    function(_) if cmp.visible() then cmp.select_next_item() else cmp.complete() end end
    , { "i", "s" }),
  ["<C-M-p>"] = cmp.mapping.select_prev_item({ count = 20 }), -- page up
  ["<C-M-n>"] = cmp.mapping.select_next_item({ count = 20 }), -- page down
  ['<C-k>'] = cmp.mapping.scroll_docs(-4),
  ['<C-j>'] = cmp.mapping.scroll_docs(4),
  ['<C-c>'] = cmp.mapping.abort(),
  ['<CR>'] = cmp.mapping.confirm({ select = true }),
  -- ['<C-CR>'] = cmp.mapping.close(),
  ["<C-l>"] = cmp.mapping(cycle_source, { "i" }),

  -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#super-tab-like-mapping
  -- https://github.com/NvChad/NvChad/blob/main/lua/plugins/configs/cmp.lua#L66
  ["<Tab>"] = cmp.mapping(action_tab, { "i", "s" }),
}

-- vim.api.nvim_buf_get_text()
local mapping_cmdline = {
  ["<C-p>"] = { c = function(_) if cmp.visible() then cmp.select_prev_item() else cmp.complete() end end },
  ["<C-n>"] = { c = function(_) if cmp.visible() then cmp.select_next_item() else cmp.complete() end end },
  ['<C-c>'] = { c = cmp.mapping.abort() },
  ['<Tab>'] = { c = cmp.mapping.confirm({ select = true }) },
  -- ['<Cr>'] = { c = cmp.mapping.confirm({ select = true }) },
}

-- Configuration for autocompletion plugin cmp
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  -- Window appearance
  -- https://github.com/NvChad/NvChad/blob/main/lua/plugins/configs/cmp.lua#L34
  -- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-get-types-on-the-left-and-offset-the-menu
  window = {
    completion = {
      border = border "CmpBorder",
      winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
      -- col_offset = -5,
      -- side_padding = 0,
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
      {
        name = 'luasnip',
        option = { show_autosnippets = false }, -- disable autosnippets to improve performance
        priority = 100,
      },
      {
        name = 'nvim_lsp',
        entry_filter = function(entry, _)
          -- Kind index
          -- https://github.com/onsails/lspkind.nvim/blob/master/lua/lspkind/init.lua#L63
          if entry:get_kind() == 1 then -- if kind is text
            return false
          end
          local word = entry:get_word()
          local ignored_words = {
            "Workspace loading:" -- lua
          }
          for _, value in ipairs(ignored_words) do
            if word:find(value) then return false end
          end
          return true
        end,
        proptity = 50
      },
    },
    {
      { name = 'buffer', keyword_length = 3 },
    },
    {
      { name = "path" },
      { name = 'calc' },
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

require("lsp_signature").setup({
  max_height = 30,
  bind = true,
  handler_opts = {
    border = "rounded"
  },
  hi_parameter = "Cursor",
  floating_window_above_cur_line = false,
})
