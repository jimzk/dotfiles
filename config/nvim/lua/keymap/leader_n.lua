local builtin = require("telescope.builtin")
require("which-key").register({
  name = "editor",
  ["/"] = {function() builtin.search_history{
      prompt_title = "Search History",
    } end, "list search history"},
  n = {"<cmd>NvimTreeToggle<cr>", "open file tree"},
  N = {"<cmd>NvimTreeFindFile!<cr>", "open file tree and focus"},
  m = {function() builtin.filetypes({
      prompt_title = "Change Filetype",
    }) end, "change filetype"},
  i = {function()
    vim.ui.input(
      {prompt = "Enter value for indent width: "},
      function(input)
        if not input then
          return
        end
        vim.bo.tabstop = tonumber(input)
        vim.bo.shiftwidth = tonumber(input)
        vim.notify("change indent width to " .. input)
      end
    )
  end, "change indent width"},
  u = {"<cmd>UndotreeToggle<cr>", "show undo history"},
  o = {function ()
    local path = vim.fn.expand("%:p:h")
    vim.cmd("silent !code " .. path)
  end, "open file by VSCode"},
  O = {function ()
    local path = vim.fn.getcwd()
    vim.cmd("silent !code " .. path)
  end, "open CWD by VSCode"},
  c = {function ()
    local path = vim.fn.expand("%:p:h")
    vim.cmd("cd " .. path)
    vim.notify("silent cd to " .. path)
  end, "cd to file location"},
  z = {"<cmd>ZenMode<cr>", "zen mode"},
  M = {"<cmd>MarksToggleSigns<cr>", "toggle marks sign"},
  t = {"<cmd>TroubleToggle telescope<cr>", "toggle telescope list (trouble)"},
  -- TODO: add cmd to search bookmark/mark
}, { mode = "n", prefix = "<leader>n", preset = true })
