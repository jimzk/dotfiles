local M = {
  "hrsh7th/nvim-cmp",
  enabled = true,
  event = {
    "InsertEnter",
    "CmdlineEnter",
  },
}

M.dependencies = {
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  { "jimzk/cmp-luasnip-choice", opts = {} },
  "saadparwaiz1/cmp_luasnip",
}

local cmp = require("cmp")
local keymaps = require("plugins.coding.nvim-cmp.keymaps")
local format = require("plugins.coding.nvim-cmp.format")

M.opts = function(_, opts)
  -- table.remove(opts.sources, 1)  -- Remove copilot
  table.insert(opts.sources, 1, {
    name = "luasnip_choice",
    group_index = 1,
    priority = 1000,
  })
  for i, source in pairs(opts.sources) do
    if source.name == "copilot" then
      table.remove(opts.sources, i)
      break
    end
  end
  for i, source in ipairs(opts.sources) do
    opts.sources[i] =
      vim.tbl_deep_extend("force", source, require("plugins.coding.nvim-cmp.sources")[source.name] or {})
  end

  -- Disable keymaps from LazyVim
  opts.mapping = {}

  local override = {
    preselect = cmp.PreselectMode.None,
    completion = {
      completeopt = "menu,menuone,noselect", -- Shoud add by manual or preselect == None not work
      -- ISSUE: Two events trigger autocomplete: InsertEnter and TextChanged.
      -- The latter is affect performance significantly, So I disable them.
      -- autocomplete = false,
      -- keyword_length = 10,
      -- },
    },
    experimental = {
      -- this feature conflict with copilot.vim's preview.
      ghost_text = false,
    },
    mapping = cmp.mapping.preset.insert(keymaps.mapping),
    -- performance = {
    --   -- max_view_entries = 7,
    --   debounce = 0, -- default is 60
    --   throttle = 0, -- default is 30
    -- },
    formatting = {
      format = format.format,
    },
    -- Show completion menu above the cursor.
    -- It is a feature from a fork branch.
    -- See: https://github.com/hrsh7th/nvim-cmp/issues/495
    --      https://github.com/hrsh7th/nvim-cmp/pull/1701
    view = {
      entries = {
        vertical_positioning = "above",
      },
    },
    window = {
      completion = {
        border = "single",
        col_offset = 2,
      },
      documentation = {
        border = "single",
      },
    },
    sorting = {
      comparators = require("plugins.coding.nvim-cmp.comparators"),
    },
  }
  opts = vim.tbl_deep_extend("force", opts or {}, override)
  return opts
end

local cmdline_opts = function(override)
  local opts = {
    window = { completion = { border = "none" } },
    completion = {
      autocomplete = {
        cmp.TriggerEvent.InsertEnter,
        cmp.TriggerEvent.TextChanged,
      },
    },
    -- https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/mapping.lua#L61
    mapping = cmp.mapping.preset.cmdline(keymaps.mapping_cmdline),
    formatting = {
      format = format.format_cmdline,
    },
  }
  opts = vim.tbl_deep_extend("force", opts or {}, override)
  return opts
end

M.config = function(_, opts)
  for _, source in ipairs(opts.sources) do
    source.group_index = source.group_index or 1
  end
  cmp.setup(opts)
  cmp.setup.cmdline(
    { "/", "?" },
    cmdline_opts({
      sources = { { name = "buffer" } },
    })
  )
  cmp.setup.cmdline(
    ":",
    cmdline_opts({
      sources = {
        { name = "cmdline" },
        { name = "path" },
      },
    })
  )
  -- History in cmdline
  vim.cmd("cnoremap <special> <M-p> <Up>")
  vim.cmd("cnoremap <special> <M-n> <Down>")
end

return M
