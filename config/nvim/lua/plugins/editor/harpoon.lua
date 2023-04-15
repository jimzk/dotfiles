return {
  -- Mark and find files
  "ThePrimeagen/harpoon",
  event = "VeryLazy",
  keys = {
    { "<leader>k", function() require("harpoon.ui").toggle_quick_menu() end, desc = "harpoon" },
    {
      "<leader>K",
      function()
        require("harpoon.mark").add_file()
        vim.notify("Add file to harpoon", vim.log.levels.INFO, { title = "Harpoon" })
      end,
      desc = "harpoon add file",
    },
    -- { "<C-]>", function() require("harpoon.ui").nav_next() end, desc = "harpoon go next" },
    -- { "<C-[>", function() require("harpoon.ui").nav_prev() end, desc = "harpoon go prev" },
    -- Navigate by file number
    { "g1", function() require("harpoon.ui").nav_file(1) end, desc = "go harpoon file 1..9" },
    { "g2", function() require("harpoon.ui").nav_file(2) end, desc = "which_key_ignore" },
    { "g3", function() require("harpoon.ui").nav_file(3) end, desc = "which_key_ignore" },
    { "g4", function() require("harpoon.ui").nav_file(4) end, desc = "which_key_ignore" },
    { "g5", function() require("harpoon.ui").nav_file(5) end, desc = "which_key_ignore" },
    { "g6", function() require("harpoon.ui").nav_file(6) end, desc = "which_key_ignore" },
    { "g7", function() require("harpoon.ui").nav_file(7) end, desc = "which_key_ignore" },
    { "g8", function() require("harpoon.ui").nav_file(8) end, desc = "which_key_ignore" },
    { "g9", function() require("harpoon.ui").nav_file(9) end, desc = "which_key_ignore" },
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
