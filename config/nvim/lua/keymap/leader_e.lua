local builtin = require("telescope.builtin")
require("which-key").register({
  name = "editor",
  ["/"] = { function()
    builtin.search_history {
      prompt_title = "Search History",
    }
  end, "list search history" },
  i = { function()
    local home = vim.fn.getenv("HOME")
    local filename = vim.fn.expand("%:p:t")
    local repo_root = vim.fn.system("git rev-parse --show-toplevel")
        :gsub(home, "~")
        :gsub("\n", "")
    local path = vim.fn.expand("%:p:h")
        :gsub(home, "~")
        :gsub(repo_root, "")
    local msg = string.format([[
  filename : %s
 repo root : %s
      path : %s
  filetype : %s
      wrap : %s
  hlsearch : %s
 incsearch : %s
ignorecase : %s]],
      filename,
      repo_root,
      path,
      vim.bo.filetype,
      vim.o.wrap,
      vim.o.hlsearch,
      vim.o.incsearch,
      vim.o.ignorecase)
    Notify(msg)
  end, "show buffer info" },
  m = { function()
    builtin.filetypes {
      prompt_title = "Set Filetype",
    }
  end, "set filetype" },
  ["<tab>"] = { function()
    vim.ui.input(
      { prompt = "Enter indent width: " },
      function(input)
        if not input then
          return
        end
        vim.bo.tabstop = tonumber(input)
        vim.bo.shiftwidth = tonumber(input)
        Notify("set indent width to " .. input)
      end
    )
  end, "set indent width" },
  u = { "<cmd>UndotreeToggle<cr>", "show undo history (undotree)" },
  o = {
    name = "path and application",
    o = { function()
      local path = vim.fn.expand("%:p")
      vim.cmd("silent !open " .. path)
    end, "open file by default application" },
    p = { function()
      local path = vim.fn.getcwd()
      vim.cmd("silent !code " .. path)
    end, "open pwd by VSCode" },
    f = { function()
      local path = vim.fn.expand("%:p:h")
      vim.cmd("silent cd " .. path)
      Notify("cd to " .. path:gsub(vim.fn.getenv("home"), "~"))
    end, "cd to file location" },
    r = { function()
      vim.cmd("Gcd")
      Notify("cd to repoitory root " .. vim.fn.getcwd():gsub(vim.fn.getenv("home"), "~"))
    end, "cd to repository root" },
  },
  z = { "<cmd>ZenMode<cr>", "zen mode" },
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
  -- TODO: add cmd to search bookmark/mark
}, { mode = "n", prefix = "<leader>e", preset = true })
