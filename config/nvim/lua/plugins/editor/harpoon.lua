return {
  -- Mark and find files
  "ThePrimeagen/harpoon",
  event = "VeryLazy",
  config = function()
    local ui = require("harpoon.ui")
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { "harpoon" },
      callback = function()
        local opts = { noremap = true, buffer = true, silent = true }
        map("n", "o", ui.select_menu_item, "select item", opts)
        map("n", "<BS>", "dd", "remove item", opts)
        for i = 1, 9, 1 do
          local number = tostring(i)
          vim.keymap.set("n", number, "<cmd>" .. number .. "<cr><cmd>lua require('harpoon.ui').select_menu_item()<cr>",
            opts)
        end
      end
    })
  end
}
