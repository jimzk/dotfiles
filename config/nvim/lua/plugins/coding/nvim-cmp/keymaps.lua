local cmp = require("cmp")
local luasnip = require("luasnip")

local M = {}

local select_item = function(direction, behavior)
  local select = (direction == "next") and cmp.select_next_item or cmp.select_prev_item
  behavior = behavior or cmp.SelectBehavior.Select -- Insert or Select
  return function(_)
    if cmp.visible() then
      select({ behavior = behavior })
      -- copilot.dismiss()
      return
    end
    -- if copilot.is_visible() then
    --   copilot[direction]()
    --   return
    -- end
    cmp.complete()
  end
end

local accept_or_jump_next = function(fallback)
  if luasnip.expandable() then
    luasnip.expand()
    return
  end

  -- if copilot.is_visible() then
  --   copilot.accept()
  --   return
  -- end

  -- if cmp.visible() then
  --   -- if cmp.get_active_entry() then
  --   local confirm = cmp.confirm({
  --     select = true,
  --     cmp.ConfirmBehavior.Replace, -- Replace or Insert (default)
  --   })
  --   if confirm then
  --     return
  --   end
  -- end

  if luasnip.locally_jumpable(1) then
    luasnip.jump(1)
    return
  end

  -- https://github.com/danymat/neogen#default-cycling-support
  local ok, neogen = pcall(require, "neogen")
  if ok and neogen.jumpable() then
    neogen.jump_next()
    return
  end

  -- cmp.complete()
  fallback()
end

local jump_prev = function(fallback)
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
    return
  end

  -- https://github.com/danymat/neogen#default-cycling-support
  local ok, neogen = pcall(require, "neogen")
  if ok and neogen.jumpable() then
    neogen.jump_prev()
    return
  end

  fallback()
end

-- local toggle = function(_)
--   if copilot.is_visible() then
--     copilot.dismiss()
--     cmp.complete()
--   elseif cmp.visible() then
--     cmp.abort()
--     -- cmp.close()
--     -- else
--     --   cmp.complete()
--   end
-- end

local switch = function()
  local copilot = require("copilot.suggestion")
  if copilot.is_visible() then
    copilot.dismiss()
    cmp.complete()
    return
  end
  if cmp.visible() then
    cmp.abort()
    copilot.next()
    return
  end
  vim.notify("No completion menu to dismiss", vim.log.levels.INFO)
end

local abort = function()
  cmp.abort()
  -- copilot.dismiss()
end

-- default mappings: https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/mapping.lua#L368
M.mapping = {
  -- Select
  ["<C-p>"] = cmp.mapping(select_item("prev"), { "i", "s" }),
  ["<C-n>"] = cmp.mapping(select_item("next"), { "i", "s" }),
  ["<Up>"] = cmp.mapping(select_item("prev"), { "i", "s" }),
  ["<Down>"] = cmp.mapping(select_item("next"), { "i", "s" }),
  -- Page up / down
  ["<C-S-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select, count = 10 }),
  ["<C-S-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select, count = 10 }),
  -- Preview scroll
  -- stylua: ignore start
  -- ["<M-k>"] = cmp.mapping.scroll_docs(-4),
  -- ["<M-j>"] = cmp.mapping.scroll_docs(4),
  ["<M-k>"] = cmp.mapping(function() cmp.scroll_docs(-4) end),
  ["<M-j>"] = cmp.mapping(function() cmp.scroll_docs(4) end),
  -- stylua: ignore end

  ["<C-c>"] = cmp.mapping(abort),
  -- ["<C-c>"] = cmp.mapping(switch),

  -- Accept
  -- https://www.reddit.com/r/neovim/comments/1at66dc/what_key_do_you_prefer_to_press_to_accept_an/
  ["<CR>"] = cmp.mapping.confirm({
    -- behavior = cmp.ConfirmBehavior.Replace,
    select = false, --  Set `select` to `false` to only confirm explicitly selected items.
  }),

  -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#super-tab-like-mapping
  -- https://github.com/NvChad/NvChad/blob/main/lua/plugins/configs/cmp.lua#L66
  ["<Tab>"] = cmp.mapping(accept_or_jump_next, { "i", "s" }),
  ["<S-Tab>"] = cmp.mapping(jump_prev, { "i", "s" }),
}

-- default mappings: https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/mapping.lua#L74
M.mapping_cmdline = {
  ["<C-p>"] = { c = select_item("prev", cmp.SelectBehavior.Insert) },
  ["<C-n>"] = { c = select_item("next", cmp.SelectBehavior.Insert) },
  ["<C-c>"] = { c = cmp.mapping.close() },
  ["<Tab>"] = {
    c = function(_)
      if cmp.visible() then
        cmp.confirm({ select = true })
      else
        cmp.complete()
      end
    end,
  },
  -- ["<CR>"] = { c = cmp.mapping.confirm({ select = true, behavior = cmp.SelectBehavior.Select }) },
}

return M
