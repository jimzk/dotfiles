require("which-key").register({
  name = "search & replace",
  s = { "<cmd>lua require('spectre').open_file_search()<cr>", "search in current file" },
  S = { "<cmd>lua require('spectre').open()<cr>", "search in workspace" },
  w = { function()
    local path = vim.fn.fnameescape(vim.fn.expand('%:p:.'))
    require("spectre").open_visual {
      select_word = true,
      path = path,
    }
  end, "search word" },
  v = { function()
    local path = vim.fn.fnameescape(vim.fn.expand('%:p:.'))
    require("spectre").open_visual {
      path = path,
    }
  end, "search visual word", mode = { "v" } },
}, { mode = { "n" }, prefix = "<leader>s", preset = true })
