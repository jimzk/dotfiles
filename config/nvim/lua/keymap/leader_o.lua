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
  ["<C-n>"] = toggle("number"),
  ["<C-r>"] = toggle("relativenumber"),
  ["<C-w>"] = toggle("wrap"),
  ["<C-c>"] = toggle("ignorecase"),
  ["<C-s>"] = toggle("hlsearch"),
  ["<C-i>"] = toggle("incsearch"),
  ["<C-p>"] = toggle("spell"),
  ["<C-h>"] = { function()
    if not vim.g.gitsigns_deleted_word_diff_enabled then
      vim.notify [[Enable highlight on Git deletion and diffs]]
      vim.g.gitsigns_deleted_word_diff_enabled = true
    else
      vim.notify [[Disable highlight on Git deletion and diffs]]
      vim.g.gitsigns_deleted_word_diff_enabled = false
    end
    vim.cmd [[Gitsigns toggle_deleted]]
    vim.cmd [[Gitsigns toggle_word_diff]]
  end, "toggle git change highlight" },
  m = { function()
    builtin.filetypes {
      prompt_title = "Set Filetype",
    }
  end, "set filetype" },
  ["<C-m>"] = { "<cmd>MarksToggleSigns<cr>", "toggle marks sign" },
  e = { "<cmd>h autocmd-events<cr>", "list autocmd event" },
  o = { function() builtin.vim_options {} end, "list vim options" },
  l = { function() builtin.highlights {} end, "list highlights" },
  c = { function() builtin.colorscheme({
      enable_preview = true,
      preview = false,
    })
  end, "avaliable colorschemes" },
  h = { function() builtin.help_tags {} end, "list help keywords" },
  a = { function() builtin.autocommands {} end, "list autocommands" },
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
  ["\\"] = { function()
    vim.cmd [[PackerClean]]
    vim.cmd [[PackerInstall]]
    vim.cmd [[PackerCompile]]
    vim.notify("Complete PackerInstall and PackerCompile", vim.log.levels.INFO, { title = "Source plugins" })
  end, "install plugin (Packer)" },
  ["<cr>"] = { function()
    local home = vim.fn.getenv("HOME")
    -- local filename = vim.fn.expand("%:p:t")
    -- local repo_root = vim.fn.system("git rev-parse --show-toplevel")
    --     :gsub(home, "~")
    --     :gsub("\n", "")
    -- local filedir = vim.fn.expand("%:p:h")
    --     :gsub(home, "~")
    --     :gsub(repo_root, "")
    local relative_file_path = vim.fn.fnamemodify(vim.fn.expand("%"), ':~:.')
    local msg = string.format([[
[cwd]
    %s
[file_path]
    %s
[file_type]
    %s
[options]
  ignorecase  %s
        wrap  %s]],
      vim.fn.getcwd():gsub(home, "~"),
      "/" .. relative_file_path,
      vim.bo.filetype,
      vim.o.ignorecase and '✅' or '❌',
      vim.o.wrap and '✅' or '❌'
    )
    require('notify')(msg, "info", { timeout = 3000 })
  end, "show buffer info" },
}, opt)
