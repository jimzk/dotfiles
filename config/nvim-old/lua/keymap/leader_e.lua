local wk = require("which-key")
wk.register({
  name = "editor",
  u = { "<cmd>UndotreeToggle<cr>", "show undo history (undotree)" },
  z = { "<cmd>ZenMode<cr>", "zen mode" },
  o = { function()
    local path = vim.fn.expand("%:p")
    vim.cmd("silent !open " .. path)
  end, "open file by VSCode" },
  v = { function()
    local path = vim.fn.getcwd()
    vim.cmd("silent !code " .. path)
  end, "open cwd by VSCode" },
  c = { function()
    local path = vim.fn.expand("%:p:h")
    vim.cmd("silent cd " .. path)
    vim.notify("cd to " .. path:gsub(vim.fn.getenv("HOME"), "~"))
  end, "cd to file directory" },
  C = { function()
    vim.cmd("Gcd")
    vim.notify("cd to repoitory root " .. vim.fn.getcwd():gsub(vim.fn.getenv("HOME"), "~"))
  end, "cd to repository root" },
  y = { function()
    local file_path = vim.fn.expand("%:p")
    vim.fn.setreg("+", file_path)
    vim.notify("File path copied", vim.log.levels.INFO)
  end, "copy file path" },
  r = { function()
    vim.ui.input(
      { prompt = "Enter new file name: " },
      function(input)
        if not input then return end
        vim.cmd("GRename " .. input)
      end)
  end, "[G] rename file" },
  m = { function()
    vim.ui.input(
      { prompt = "Move file to: " },
      function(input)
        if not input then return end
        vim.cmd("GMove " .. input)
      end)
  end, "[G] move file" },
  d = { function()
    vim.cmd("GDelete")
  end, "[G] delete file" },
  D = { function()
    vim.cmd("GDelete!")
  end, "[G] delete file forcely" },
  g = { "<cmd>GBrowse!<cr>", "copy git url for file" },
  G = { "<cmd>GBrowse<cr>", "open git url for file" }
}, { mode = "n", prefix = "<leader>e", preset = true })

wk.register({
  g = { function()
    vim.cmd [[normal "vy]]
    vim.cmd [['<,'>GBrowse!]]
  end, "[G] copy git url for range", mode = "v" },
  G = { function()
    vim.cmd [[normal "vy]]
    vim.cmd [['<,'>GBrowse]]
  end, "[G] copy git url for range", mode = "v" },
}, { prefix = "<leader>e" })
