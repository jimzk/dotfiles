local toggle = function(opt)
  local f = function()
    local opts = vim.o
    if opts[opt] then
      opts[opt] = false
      vim.notify("Disable " .. opt)
    else
      opts[opt] = true
      vim.notify("Enable " .. opt)
    end
  end
  return { f, "toggle " .. opt }
end

local opt = { mode = "n", prefix = "<leader>o", noremap = true, silent = true }
local builtin = require("telescope.builtin")
require("which-key").register({
  name = "options",
  n = toggle("number"),
  r = toggle("relativenumber"),
  w = toggle("wrap"),
  c = toggle("ignorecase"),
  s = toggle("hlsearch"),
  i = toggle("incsearch"),
  p = toggle("spell"),
  P = { function()
    local path = vim.fn.stdpath("data") .. "/telescope-projects.txt"
    vim.cmd("!rm " .. path)
    vim.notify("Clean telescope-projects cache")
  end, "clean telescope.project cache" },
  m = { "<cmd>MarksToggleSigns<cr>", "toggle marks sign" },
  M = { "<cmd>DeleteSession<cr>", "delete session" },
  e = { "<cmd>h autocmd-events<cr>", "list autocmd event" },
  o = { function() builtin.vim_options {} end, "list vim options" },
  l = { function() builtin.highlights {} end, "list highlights" },
  z = { function() builtin.colorscheme({
      enable_preview = true,
      preview = false,
    })
  end, "avaliable colorschemes" },
  h = { function() builtin.help_tags {} end, "show help keywords" },
  a = { function() builtin.autocommands {} end, "autocommands" },
  k = { "<cmd>Telescope keymaps<cr>", "list all keymaps" },
  ["<tab>"] = { function()
    vim.ui.input(
      { prompt = "Enter indent width: " },
      function(input)
        if not input then
          return
        end
        vim.bo.tabstop = tonumber(input)
        vim.bo.shiftwidth = tonumber(input)
        vim.notify("Set indent width to " .. input)
      end
    )
  end, "set indent width" },
}, opt)
