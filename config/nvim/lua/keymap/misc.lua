local wk = require("which-key")
local opt = { mode = "n", noremap = true, silent = true }

wk.register({
  ["<C-h>"] = { "<C-w>h", "go left win" },
  ["<C-j>"] = { "<C-w>j", "go down win" },
  ["<C-k>"] = { "<C-w>k", "go up win" },
  ["<C-l>"] = { "<C-w>l", "go right win" },
  ["<C-S-h>"] = { "<C-w>H", "move win left" },
  ["<C-S-j>"] = { "<C-w>J", "move win down" },
  ["<C-S-k>"] = { "<C-w>K", "move win up" },
  ["<C-S-l>"] = { "<C-w>L", "move win right" },
  ["<Tab>"] = { "<cmd>wincmd p<cr>", "✭ go last accessed win" },
  -- ["<C-z>"] = { "<cmd>normal u<cr>", "undo", mode = { "i" } },
  -- window size
  ["<C-M-k>"] = { "<c-w>+", "increase win height" },
  ["<C-M-j>"] = { "<c-w>-", "decrease win height" },
  ["<C-M-h>"] = { "<c-w><", "decrease win width" },
  ["<C-M-l>"] = { "<c-w>>", "increase win width" },
  -- alternative buffer
  ["_"] = { "<C-^>", "✭ alternative buffer" },
  ["<M-_>"] = { "<cmd>split #<cr>", "✭ split alternative buffer" },
  -- tab
  ["-"] = { "<cmd>tabnext<cr>", "next tab" },
  ["="] = { "<cmd>tabprev<cr>", "prev tab" },
  -- delete buffer
  -- ["<BS>"] = { "<cmd>Bdelete<cr>", "delete buffer" },
  ["<BS>"] = { "<cmd>Bwipeout<cr>", "delete buffer" },
  ["<C-BS>"] = { "<cmd>Bwipeout!<cr>", "delete buffer forcely" },
  ["<S-BS>"] = { "<cmd>bufdo Bwipeout<cr>", "delete all buffer" },
  -- quit
  ["q"] = { "<cmd>x<cr>", "which_key_ignore" },
  ["<C-q>"] = { "<cmd>xa<cr>", "which_key_ignore" }, -- Quite vim
  -- ["<M-q>"] = { "q", "remapped q" },
}, opt)

wk.register({
  ["<C-->"] = { function()
    local height = vim.api.nvim_win_get_height(0)
    if height + 8 >= vim.o.lines then
      vim.cmd [[vertical wincmd =]]
    else
      vim.cmd [[wincmd _]]
    end
  end, "max win width" },
  ["<C-\\>"] = { function()
    local width = vim.api.nvim_win_get_width(0)
    if width + 8 >= vim.o.columns then
      vim.cmd [[horizontal wincmd =]]
    else
      vim.cmd [[wincmd |]]
    end
  end, "max win width" },
  ["<C-=>"] = { function()
    vim.cmd [[wincmd =]]
  end, "equal win size" },
}, opt)

wk.register({
  -- mg979/vim-visual-multi
  ["<S-up>"] = { "<Plug>(VM-Select-Cursor-Up)", "visual up" },
  ["<S-down>"] = { "<Plug>(VM-Select-Cursor-Down)", "visual down" },
  ["<S-left>"] = "visual left",
  ["<S-right>"] = "visual right",
  ["<M-k>"] = "multi select up",
  ["<M-j>"] = "multi select down",
}, opt)

set({ "n", "i" }, "<S-cr>", function()
  local pos = vim.api.nvim_win_get_cursor(0)
  local mode = vim.fn.mode()
  local cmd = mode == "n" and [[a\<cr>]] or [[i\<cr>]]
  vim.cmd([[execute "normal! ]] .. cmd .. [["]])
  vim.api.nvim_win_set_cursor(0, pos)
end, { desc = "break line" })

set("i", "<C-h>", "<Left>")
set("i", "<C-l>", "<Right>")
set("i", "<C-j>", "<Down>")
set("i", "<C-k>", "<Up>")

-- set("c", "<C-space>", "<cr>", { noremap = true, silent = true })

-- https://github.com/mhinz/vim-galore#quickly-move-current-line
set("n", "<M-[>", [[<cmd>execute "move -1-". v:count1<cr>]], { desc = "move line up" })
set("n", "<M-]>", [[<cmd>execute "move +". v:count1<cr>]], { desc = "move line up" })
set("v", "<M-[>", [["vy<cmd>execute "'<,'>move '<-1-". v:count1<cr>gv=gv]], { desc = "move line up" })
set("v", "<M-]>", [["vy<cmd>execute "'<,'>move '>+". v:count1<cr>gv=gv]], { desc = "move line up" })
