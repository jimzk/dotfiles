local M = {
  "Bekaboo/dropbar.nvim",
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
  },
  event = "BufReadPost",
  -- winbar is so annoying so I disable it.
  enabled = false,
}

M.keys = function()
  -- https://github.com/Bekaboo/dropbar.nvim#api
  local api = require("dropbar.api")
  return {
    -- { "<M-i>", api.pick, desc = "Pick Symbol (Dropbar)" },
    { "<leader>ii", api.pick, desc = "Pick Symbol (Dropbar)" },
    { "<leader>in", api.select_next_context, desc = "Symbol Down (Dropbar)" },
    { "<leader>ip", api.goto_context_start, desc = "Symbol Up (Dropbar)" },
  }
end

M.opts = {
  sources = {
    path = {
      filter = function(name)
        return name ~= ".DS_Store"
      end,
    },
  },
  menu = {
    entry = {
      padding = {
        left = 0,
        right = 1,
      },
    },
    keymaps = {
      ["<Tab>"] = "",
      ["<C-i>"] = "",
      ["<C-o>"] = "",
      -- ["h"] = "<C-w>q",
      ["h"] = function()
        local menu = require("dropbar.utils").menu.get()
        local menu_count = 0
        for _, _ in pairs(menu) do
          menu_count = menu_count + 1
        end
        vim.cmd("wincmd q")
        if menu_count == 1 then
          vim.schedule(require("dropbar.api").pick)
        end
      end,
      ["l"] = function()
        local menu = require("dropbar.utils").menu.get_current()
        if not menu then
          return
        end
        local cursor = vim.api.nvim_win_get_cursor(menu.win)
        local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
        -- I don't want l jump to any component
        if component and component.children and #component.children > 0 then
          menu:click_on(component, nil, 1, "l")
        end
      end,
      ["<CR>"] = function()
        local menu = require("dropbar.utils").menu.get_current()
        if not menu then
          return
        end
        local cursor = vim.api.nvim_win_get_cursor(menu.win)
        local entry = menu.entries[cursor[1]]
        local component = entry:first_clickable(entry.padding.left + entry.components[1]:bytewidth())
        if component then
          menu:click_on(component, nil, 1, "l")
        end
      end,
      ["i"] = "",
      ["f"] = function()
        local menu = require("dropbar.utils").menu.get_current()
        if not menu then
          return
        end
        menu:fuzzy_find_open()
      end,
    },
  },
}

return M
