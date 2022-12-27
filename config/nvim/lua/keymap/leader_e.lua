local builtin = require("telescope.builtin")
require("which-key").register({
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
  f = {
    name = "file operations",
    r = { function()
      vim.ui.input(
        { prompt = "Enter new file name: " },
        function(input)
          vim.cmd(":GRename " .. input)
        end)
    end, "[G] rename file" },
    m = { function()
      vim.ui.input(
        { prompt = "Move file to: " },
        function(input)
          vim.cmd(":GMove " .. input)
        end)
    end, "[G] move file" },
    d = { function()
      vim.cmd(":GDelete")
    end, "[G] delete file" },
  },
}, { mode = "n", prefix = "<leader>e", preset = true })
