return {
  "tpope/vim-fugitive",
  dependencies = {
    "tpope/vim-rhubarb", -- Support :Browse of fugitive
  },
  event = "VeryLazy",
  keys = {
    {
      "<leader>ggf",
      -- "<cmd>Git<cr><cmd>wincmd L<cr><cmd>vertical resize 60<cr><cmd>6<cr>",
      "<cmd>Git<cr>",
      desc = "Git (fugitive)",
    },
    -- { "<leader>gB", "<cmd>Git blame --date=relative<cr>", desc = "File Blame (fugitive)" },
    {
      "<leader>gB",
      "<cmd>Git blame --date=format:'%Y-%m-%d %H:%M'<cr>",
      desc = "File Blame (fugitive)",
    },
    {
      mode = "n",
      "<leader>go",
      function()
        local clipboard = vim.fn.getreg("+")
        vim.cmd([[silent! GBrowse!]])
        local url = vim.fn.getreg("+")
        local line, _ = unpack(vim.api.nvim_win_get_cursor(0))
        url = url .. [[\#L]] .. tonumber(line)
        vim.cmd([[silent! !open "]] .. url .. [["]])
        vim.fn.setreg("+", clipboard)
      end,
      desc = "Open File's GitHub URL",
    },
    {
      mode = "n",
      "<leader>gO",
      function()
        vim.cmd([[silent! GBrowse!]])
        local url = vim.fn.getreg("+")
        local line, _ = unpack(vim.api.nvim_win_get_cursor(0))
        url = url .. [[#L]] .. tonumber(line)
        vim.fn.setreg("+", url)
      end,
      desc = "Copy File's GitHub URL",
    },

    { mode = "x", "<leader>go", [["vy<cmd>'<,'>GBrowse<cr>]], desc = "Open File's Ranged GitHub URL" },
    { mode = "x", "<leader>gO", [["vy<cmd>'<,'>GBrowse!<cr>]], desc = "Copy File's Ranged GitHub URL" },
  },
  init = function()
    local help_tags = {
      ["fugitiveblame"] = "Git_blame",
      ["fugitive"] = "fugitive-map",
    }
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "fugitiveblame", "fugitive" },
      callback = function()
        local cmd = string.format("<cmd>h %s<cr>", help_tags[vim.bo.filetype])
        vim.keymap.set("n", "?", cmd, { buffer = true, silent = true })
        vim.keymap.set("n", "<Tab>", "dv", { remap = true, buffer = true, silent = true }) -- Diff
      end,
    })
  end,
}
