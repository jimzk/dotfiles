local cmp = require("cmp")
local copilot = require("copilot.suggestion")
local luasnip = require("luasnip")

local M = {}
-- My completion logic
-- 1. Auto trigger Cmp.
-- 2. <C-c> dismiss Cmp and trigger Copilot.
-- 3. <C-n> and <C-p> select next and prev item in Copilot or Cmp.
-- 4. <space> insert space and trigger Copilot.
-- 5. Auto trigger Cmp for cmdline

local select_item = function(direction, behavior)
  local select = (direction == "next") and cmp.select_next_item or cmp.select_prev_item
  behavior = behavior or cmp.SelectBehavior.Select -- Insert or Select
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
  if copilot.is_visible() then
    copilot.accept()
    return
  end

  if cmp.visible() then
    local confirmed = cmp.confirm {
      select = should_select(),
      cmp.ConfirmBehavior.Replace -- Replace or Insert (default)
    }
    if confirmed then return end
  end

  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  -- Aborting means I don't want to expand
  if luasnip.expandable() and not vim.g.abort then
    luasnip.expand()
  elseif luasnip.locally_jumpable() then
    luasnip.jump(1)
  end
  -- Sometime luasnip jumps but still in the same position.
  -- In this case we fallback to tabout.
  local line2, col2 = unpack(vim.api.nvim_win_get_cursor(0))
  if line == line2 and col == col2 then
    fallback()
  end
  vim.g.abort = false
end

local s_tab = function(fallback)
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    fallback()
  end
end

local abort = function(_)
  if cmp.visible() then
    cmp.abort()
    copilot.next()
  elseif copilot.is_visible() then
    copilot.dismiss()
  else
    cmp.complete()
  end
  vim.g.abort = not cmp.visible()
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

M.mapping = {
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


M.mapping_cmdline = {
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

return M
