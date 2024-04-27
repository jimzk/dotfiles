local M = {
  "ThePrimeagen/harpoon",
}

M.opts = {
  settings = {
    save_on_toggle = true,
    sync_on_ui_close = true,
    tabline = true,
    tabline_prefix = "   ",
    tabline_suffix = "   ",
  },
}

M.config = function(_, opts)
  require("harpoon").setup(opts)

  local map = Util.map
  map("n", "<M-i>", require("harpoon.ui").nav_next, "Prev Harpoon")
  map("n", "<M-o>", require("harpoon.ui").nav_prev, "Next Harpoon")

  map("n", "<leader>k", function()
    require("harpoon.mark").add_file()
    vim.notify("Add file to harpoon")
  end, "Add to Harpoon")
  map("n", "<leader><C-k>", require("harpoon.ui").toggle_quick_menu, "Harpoon")

  for i = 0, 9, 1 do
    map("n", "<leader>" .. tostring(i), function()
      require("harpoon.ui").nav_file(i)
    end)
  end

  vim.cmd("highlight! HarpoonInactive guibg=NONE guifg=#63698c")
  vim.cmd("highlight! HarpoonActive guibg=NONE guifg=white")
  vim.cmd("highlight! HarpoonNumberActive guibg=NONE guifg=#7aa2f7")
  vim.cmd("highlight! HarpoonNumberInactive guibg=NONE guifg=#7aa2f7")
  vim.cmd("highlight! TabLineFill guibg=NONE guifg=white")
end

return M
