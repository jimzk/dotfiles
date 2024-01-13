local M = {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  event = "BufReadPost",
  enabled = false,
  dependencies = { "nvim-lua/plenary.nvim" },
}

M.opts = {
  settings = {
    save_on_toggle = true,
    sync_on_ui_close = true,
  },
  default = {},
}

_G.remove_harpoon = function()
  local bufnr = vim.api.nvim_get_current_buf()
  -- local filename = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":t")
  local buf_relative_path = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":~:.")
  local items = require("harpoon"):list().items
  for idx, item in ipairs(items) do
    if item.value == buf_relative_path then
      table.remove(items, idx)
      -- vim.notify("Remove " .. filename .. " from Harpoon", vim.log.levels.WARN, { title = "Harpoon" })
      return true
    end
  end
  return false
end

M.keys = {
  {
    "<M-p>",
    function()
      -- vim.cmd("BufferPin")
      if _G.remove_harpoon() then
        return
      end
      require("harpoon"):list():append()
      -- vim.notify("Add " .. filename .. " to Harpoon", vim.log.levels.INFO, { title = "Harpoon" })
    end,
    -- desc = "Add/Remove File in Harpoon",
    desc = "Harpoon Toggle",
  },
  {
    "<leader>bh",
    function()
      local harpoon = require("harpoon")
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end,
    desc = "Harpoon List",
  },
  {
    "=",
    function()
      require("harpoon"):list():next({
        ui_nav_wrap = true,
      })
    end,
    desc = "Next Harpoon",
  },
  {
    "-",
    function()
      require("harpoon"):list():prev({
        ui_nav_wrap = true,
      })
    end,
    desc = "Prev Harpoon",
  },
}

M.config = function(_, opts)
  local harpoon = require("harpoon")
  harpoon:setup(opts)
  local map = require("util").map
  for i = 0, 9, 1 do
    local is_1 = i == 1
    map("n", "<M-" .. tostring(i) .. ">", function()
      harpoon:list():select(i)
    end, is_1 and "Navigate Harpoon File 1" or nil)
  end

  -- https://github.com/ThePrimeagen/harpoon/tree/harpoon2?tab=readme-ov-file#extend
  harpoon:extend({
    UI_CREATE = function(cx)
      vim.keymap.set("n", "<C-v>", function()
        harpoon.ui:select_menu_item({ vsplit = true })
      end, { buffer = cx.bufnr })
      vim.keymap.set("n", "<C-x>", function()
        harpoon.ui:select_menu_item({ split = true })
      end, { buffer = cx.bufnr })
      vim.keymap.set("n", "<C-t>", function()
        harpoon.ui:select_menu_item({ tabedit = true })
      end, { buffer = cx.bufnr })
    end,
  })
end

return M
