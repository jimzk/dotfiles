-- Fix * in visual mode alwasy reselect search word
vim.keymap.set("v", "*", [[y/\V<C-R>=escape(@",'/\')<CR><CR>]], { noremap = true })

local wk = require("which-key")
wk.register({
  j = "which_key_ignore",
  k = "which_key_ignore",
  y = {
    name = "copy",
    s = {
      s = "[M] yss) add () to entire line",
    }
  },
  ["<lt>"] = { "indent left" },
  [">"] = { "indent right" },
  ["<C-e>"] = "which_key_ignore",
  ["<C-y>"] = "which_key_ignore",
}, { prefix = "", preset = true })

local opt = { mode = { "n", "v" }, noremap = true, silent = true }
wk.register({
  ["<C-c>"] = { "<cmd>:q<cr>", "quit", mode = { "n", "i" } },
  ["<C-s>"] = { "<cmd>:w<cr>", "write", mode = { "n", "i" } },
  ["<C-h>"] = { "<C-w>h", "left window" },
  ["<C-j>"] = { "<C-w>j", "down window" },
  ["<C-k>"] = { "<C-w>k", "up window" },
  ["<C-l>"] = { "<C-w>l", "right window" },
  -- ["<C-,>"] = { "<C-^>", "alternative buffer" },
  ["<C-g>"] = { "<C-w>p", "go last accessed window" },
  -- Compared with :bdelete, :bwipeout remove buffer from jumplist.
  -- :Bdelete and :Bwipeout are suppotred by moll/vim.bbye
  ["<C-_>"] = { "<cmd>Bdelete<cr>", "delete buffer" },
  ["<C-BS>"] = { "<cmd>Bwipeout<cr><cmd>bnext<cr><C-^>", "delete buffer with jumplist" },
  ["<A-BS>"] = { function()
    vim.cmd [[%bd]]
    vim.cmd [[e#]]
    vim.cmd [[bnext]]
    vim.cmd [[bd]]
    Notify("Delete other buffers")
  end, "delete others buffers" },
  ["<C-r>"] = { function()
    require('spectre').open_file_search()
  end, "search and repalce (spectre)" },
  ["<C-z>"] = { "<cmd>normal u<cr>", "undo", mode = { "i" } },
  ["<C-cr>"] = { "<cmd>noh<cr>", "clear search highlight" },
}, opt)

wk.register({
  ["<C-r>"] = { function()
    vim.cmd('noau normal! "vy"')
    local content = vim.fn.getreg('v')
    local path = vim.fn.fnameescape(vim.fn.expand('%:p:.'))
    require("spectre").open {
      search_text = content,
      path = path,
    }
  end, "search and replace (spectre)", mode = { "v" } },
}, opt)

wk.register({
  -- /mg979/vim-visual-multi
  ["<S-up>"] = { "<Plug>(VM-Select-Cursor-Up)", "visual up" },
  ["<S-down>"] = { "<Plug>(VM-Select-Cursor-Down)", "visual down" },
  ["<S-left>"] = "visual left",
  ["<S-right>"] = "visual right",
  ["<C-up>"] = "multi select up",
  ["<C-down>"] = "multi select down",
}, opt)

vim.keymap.set("n", "<C-i>", "<C-i>zz", { noremap = true })
vim.keymap.set("n", "<C-o>", "<C-o>zz", { noremap = true })
vim.keymap.set("c", "<C-space>", "<cr>")
