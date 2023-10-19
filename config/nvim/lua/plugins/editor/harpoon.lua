return {
  -- Mark and find files
  "ThePrimeagen/harpoon",
  event = "VeryLazy",
  keys = {
    { "<leader>K", function() require("harpoon.mark").toggle_file() end, desc = "harpoon toggle file", },
    { "<leader>k", function() require("harpoon.ui").toggle_quick_menu() end, desc = "harpoon menu", },
    -- { "-", function() require("harpoon.ui").nav_prev() end, desc = "pre harpoon file", },
    -- { "=", function() require("harpoon.ui").nav_next() end, desc = "next harpoon file", },
    -- Navigate by file number
    { "<leader>1", function() require("harpoon.ui").nav_file(1) end, desc = "go to harpoon file 1" },
    { "<leader>2", function() require("harpoon.ui").nav_file(2) end, desc = "which_key_ignore" },
    { "<leader>3", function() require("harpoon.ui").nav_file(3) end, desc = "which_key_ignore" },
    { "<leader>4", function() require("harpoon.ui").nav_file(4) end, desc = "which_key_ignore" },
    { "<leader>5", function() require("harpoon.ui").nav_file(5) end, desc = "which_key_ignore" },
    { "<leader>6", function() require("harpoon.ui").nav_file(6) end, desc = "which_key_ignore" },
    { "<leader>7", function() require("harpoon.ui").nav_file(7) end, desc = "which_key_ignore" },
    { "<leader>8", function() require("harpoon.ui").nav_file(8) end, desc = "which_key_ignore" },
    { "<leader>9", function() require("harpoon.ui").nav_file(9) end, desc = "which_key_ignore" },
  },
  opts = {},
  config = function(_, opts)
    require("harpoon").setup(opts)
    local ui = require("harpoon.ui")
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "harpoon" },
      callback = function()
        local opts = { noremap = true, buffer = true, silent = true }
        map("n", "o", ui.select_menu_item, "select item", opts)
        map("n", "<cr>", ui.select_menu_item, "select item", opts)
        map("n", "<BS>", "dd", "remove item", opts)
        for i = 1, 9, 1 do
          local number = tostring(i)
          vim.keymap.set("n", number,
            "<cmd>" .. number .. "<cr><cmd>lua require('harpoon.ui').select_menu_item()<cr>",
            opts
          )
        end
      end,
    })
  end,
}
