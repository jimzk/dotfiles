local M = {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  event = "BufReadPost",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "akinsho/bufferline.nvim",
      enabled = false,
    },
  },
}

M.opts = {
  settings = {
    save_on_toggle = true,
    sync_on_ui_close = true,
  },
  default = {},
}

M.keys = {
  {
    "<M-i>",
    function()
      require("harpoon"):list():prev()
    end,
    desc = "Prev Harpoon",
  },
  {
    "<M-o>",
    function()
      require("harpoon"):list():next()
    end,
    desc = "Next Harpoon",
  },
  {
    "<leader>k",
    function()
      local bufnr = vim.api.nvim_get_current_buf()
      local buf_relative_path = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":~:.")
      local items = require("harpoon"):list().items
      for idx, item in ipairs(items) do
        if item.value == buf_relative_path then
          table.remove(items, idx)
          return
        end
      end
      require("harpoon"):list():append()
    end,
    desc = "Add/Remove File in Harpoon",
  },
  {
    "<leader><C-k>",
    function()
      local harpoon = require("harpoon")
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end,
    desc = "Harpoon List",
  },
}

M.config = function(_, opts)
  local harpoon = require("harpoon")
  harpoon:setup(opts)
  local map = Util.map
  for i = 0, 9, 1 do
    local is_1 = i == 1
    map("n", "<space>" .. tostring(i), function()
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
