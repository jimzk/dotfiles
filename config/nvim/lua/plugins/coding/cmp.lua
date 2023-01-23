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

-- My completion logic
-- 1. Auto trigger Cmp.
-- 2. <C-c> dismiss Cmp and trigger Copilot.
-- 3. <C-n> and <C-p> select next and prev item in Copilot or Cmp.
-- 4. Auto trigger Cmp for cmdline
local select_item = function(direction, behavior)
  local cmp = require("cmp")
  local select = (direction == "next") and cmp.select_next_item or cmp.select_prev_item
  behavior = behavior or cmp.SelectBehavior.Select -- Insert or Select

  local copilot = require("copilot.suggestion")
  local copilot_select = (direction == "next") and copilot.next or copilot.prev

  return function(_)
    if copilot.is_visible() then
      copilot_select()
      return
    end

    if cmp.visible() then
      select { behavior = behavior }
    else
      cmp.complete()
    end
  end
end

local my_mapping = function()
  local cmp = require("cmp")
  local luasnip = require("luasnip")

  local should_select = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    if col == 0 then return true end
    local text = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
    local last_char = text:sub(col, col)
    -- Jump if last_char is ., :, _, - or alphanumeric chara
    -- OR reserve match? If not whitespace, ,, {, (, [
    return last_char:match("[%.%:%-%_%w]") ~= nil
  end

  local tab = function(fallback)
    local copilot = require("copilot.suggestion")
    if copilot.is_visible() then
      copilot.accept()
      return
    end

    if cmp.visible() then
      -- vim.notify("cmp visible")
      local confirmed = cmp.confirm {
        select = should_select(),
        cmp.ConfirmBehavior.Replace -- Replace or Insert (default)
      }
      if confirmed then
        return
      end
    end

    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    -- Aborting means I don't want to expand
    if luasnip.expandable() and not vim.g.abort then
      -- vim.notify("luasnip expand")
      luasnip.expand()
    elseif luasnip.locally_jumpable() then
      -- vim.notify("luasnip jump")
      luasnip.jump(1)
    end
    -- Sometime luasnip jumps but still in the same position.
    -- In this case we fallback to tabout.
    local line2, col2 = unpack(vim.api.nvim_win_get_cursor(0))
    if line == line2 and col == col2 then
      -- vim.notify("fallback")
      fallback()
    end
    vim.g.abort = false
  end

  local abort = function(_)
    local copilot = require("copilot.suggestion")
    -- If cmp is visible, dismiss it and trigger Copilot
    if cmp.visible() then
      cmp.abort()
      return
    end
    -- If Copilot is visible, dismiss it
    if copilot.is_visible() then
      copilot.dismiss()
      return
    end
    vim.g.abort = true
    -- -- If Copilot is visible, dismiss it and trigger cmp
    -- if copilot.is_visible() then
    --   copilot.dismiss()
    --   cmp.complete()
    --   return
    -- end
    -- -- If Copilot is not visible, abort cmp
    -- cmp.abort()
    -- vim.g.abort = true
  end

  local s_tab = function(fallback)
    if luasnip.jumpable(-1) then
      luasnip.jump(-1)
      return
    end
    fallback()
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
    ["<C-c>"] = cmp.mapping(abort),

    -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ["<CR>"] = cmp.mapping.confirm({ select = false }),

    -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#super-tab-like-mapping
    -- https://github.com/NvChad/NvChad/blob/main/lua/plugins/configs/cmp.lua#L66
    ["<Tab>"] = cmp.mapping(tab, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(s_tab, { "i", "s" }),

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
    ["<Tab>"] = { c = function(_)
      if cmp.visible() then
        cmp.confirm({ select = true })
      else
        cmp.complete()
      end
    end }
    -- ["<CR>"] = { c = cmp.mapping.confirm({ select = true }) },
  }
end

M.config = function()
  local cmp = require("cmp")
  local icons = require("config").icons.kinds
  local lsp_ignored_words = {
    "Workspace loading:", -- lua
  }
  cmp.setup({
    completion = {
      completeopt = "menu,menuone,noselect",
      -- autocomplete = false,  -- Prefer cmp than Copilot
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
      { name = "buffer", keyword_length = 4 },
      { name = "path" },
    }),
    window = {
      completion = {
        border = "single",
      },
      documentation = {
        border = "single"
      },
    },
    formatting = {
      format = function(entry, item)
        -- if entry.source.name == "copilot" then
        --   item.kind = "Copilot"
        --   item.abbr = item.abbr:gsub("^%s+", "")
        -- end
        item.kind = (icons[item.kind] or "") .. item.kind
        -- https://github.com/hrsh7th/nvim-cmp/discussions/609#discussioncomment-3395522
        if #item.abbr > 30 then
          item.abbr = vim.fn.strcharpart(item.abbr, 0, 30) .. "…"
        end
        return item
      end,
    },
    experimental = {
      ghost_text = {
        -- highlight for inline text shown by cmp.SelectBehavior.Select
        hl_group = "Comment",
        -- hl_group = "LspReferenceText",
      },
    },
  })
  -- Make color consisten
  vim.cmd [[hi Pmenu guibg=none]]

  cmp.setup.cmdline({ "/", "?" }, {
    -- remove noselect
    completion = {
      completeopt = "menu,menuone,noinsert",
      autocomplete = { cmp.TriggerEvent.TextChanged },
    },
    window = { completion = { border = "none", }, },
    -- https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/mapping.lua#L61
    mapping = cmp.mapping.preset.cmdline(my_mapping_cmdline()),
    sources = {
      { name = "buffer" },
    },
  })

  cmp.setup.cmdline(":", {
    -- remove noselect
    completion = {
      completeopt = "menu,menuone,noinsert",
      autocomplete = { cmp.TriggerEvent.TextChanged },
    },
    window = { completion = { border = "none", }, },
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
