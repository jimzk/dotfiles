-- https://github.com/ThePrimeagen/harpoon
local ui = require("harpoon.ui")
vim.api.nvim_create_autocmd('FileType', {
  pattern = { "harpoon" },
  callback = function()
    local opts = { noremap = true, buffer = true, silent = true }
    vim.keymap.set("n", "l", ui.select_menu_item, opts)
    vim.keymap.set("n", "<BS>", "dd", opts)
    vim.keymap.set("n", "<Tab>", harpoon_marks, opts)
    for i = 1, 9, 1 do
      local number = tostring(i)
      vim.keymap.set("n", number, "<cmd>" .. number .. "<cr><cmd>lua require('harpoon.ui').select_menu_item()<cr>", opts)
    end
  end
})
require("telescope").load_extension('harpoon')

-- Can't set keymap
-- workaround: https://github.com/ThePrimeagen/harpoon/issues/178#issuecomment-1174520639
-- default keymap: https://github.com/ThePrimeagen/harpoon/blob/master/lua/telescope/_extensions/marks.lua#L122
local reorder_items = function(_)
  ui.toggle_quick_menu()
end
_G.harpoon_marks = function()
  require('telescope').extensions.harpoon.marks({
    attach_mappings = function(_, map)
      local actions = require("telescope.actions")
      map("i", "<Tab>", reorder_items)
      map('i', "<down>", actions.move_selection_next)
      map('i', "<up>", actions.move_selection_previous)
      map('i', "<C-n>", actions.move_selection_next)
      map('i', "<C-p>", actions.move_selection_previous)
      return true
    end
  })
end

-- set("n", "<C-g>", require('harpoon.ui').toggle_quick_menu, { desc = "go marked file (harpoon)" })
-- set("n", "<C-S-g>", function()
--   require("harpoon.mark").add_file()
--   vim.notify("File marked!", vim.log.levels.INFO, { title = "Harpoon" })
-- end, { desc = "mark file (harpoon)" })
