local builtin = require("telescope.builtin")
local wk = require("which-key")
local opt = { mode = "n", prefix = "<leader>", noremap = true, silent = true }
wk.register({
  ["`"] = { "<cmd>qa<cr>", "quit all" },
  ["~"] = { "<cmd>qa!<cr>", "quit all forcely" },
  q = { "<cmd>q<cr>", "quit" },
  ["<C-q>"] = { "<cmd>q!<cr>", "quit forcely" },
  w = { "<cmd>w<cr>", "write" },
  W = { function()
    vim.cmd [[wa]]
    vim.notify("Write all!")
  end, "write all" },
  n = { "<cmd>NvimTreeToggle<cr>", "open nvim-tree" },
  N = { "<cmd>NvimTreeFindFile!<cr>", "open nvim-tree and focus" },
  ["<cr>"] = { "<cmd>Gitsigns preview_hunk<cr>", "[G] preview current change" },
  ["<tab>"] = { "<cmd>Telescope resume<cr>", "last telescope history" },
  ["<S-tab>"] = { "<cmd>Telescope pickers<cr>", "All telescope history" },
  a = { function()
    vim.cmd [[Gitsigns stage_hunk]]
    vim.cmd [[w]]
  end, "[G] stage current hunk", mode = { "n", "v" } },
  A = { function()
    vim.cmd [[Gitsigns stage_buffer]]
    vim.cmd [[w]]
  end, "[G] stage buffer" },
  ["<C-a>"] = { "<cmd>Gitsigns undo_stage_hunk<cr>", "[G] undo staged hunk" },
  u = { "<cmd>Gitsigns reset_hunk<cr>", "[G] revert current change" },
  U = { "<cmd>Gitsigns reset_buffer<cr>", "[G] revert buffer" },
  b = { function()
    builtin.buffers(require("telescope.themes").get_ivy {
      prompt_title = "Buffers List",
      results_title = "|open: ^v(split) ^s(plit) ^t(ab)",
      sort_lastused = true,
    })
  end, "go buffers" },
  l = { function()
    vim.lsp.buf.format { async = false }
    vim.cmd [[w]] -- Save after format
  end, "format file (by lsp)", mode = { "n", "v" } },
  -- Compared with :bdelete, :bwipeout remove buffer from jumplist.
  -- :Bdelete and :Bwipeout are suppotred by moll/vim.bbye
  ["-"] = { "<cmd>Bdelete<cr>", "delete buffer" },
  ["_"] = { function()
    vim.cmd [[Bwipeout]]
  end, "delete buffer with jumplist" },
  ["<M-->"] = { function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd [[%bd | e# | bnext | bd]]
    vim.api.nvim_win_set_cursor(0, pos)
    vim.notify("Delete all other buffers!")
  end, "delete others buffers" },
  ["\\"] = { function()
    vim.cmd [[PackerClean]]
    vim.cmd [[PackerInstall]]
    vim.cmd [[PackerCompile]]
    require("notify")("Complete PackerInstall and PackerCompile", "info", { title = "Source plugins" })
  end, "install plugin (Packer)" },
  d = { [[V"vY'>"vp]], "duplicate line" },
  r = { function()
    require('spectre').open_file_search()
  end, "search and repalce (spectre)" },
}, opt)

wk.register({
  d = { [["vY'>"vp]], "duplicate lines", mode = "v" },
  r = { function()
    vim.cmd('noau normal! "vy"')
    local content = vim.fn.getreg('v')
    local path = vim.fn.fnameescape(vim.fn.expand('%:p:.'))
    require("spectre").open {
      search_text = content,
      path = path,
    }
  end, "search and replace (spectre)", mode = "v" },
}, opt)

-- Hop
wk.register({
  k = { "<cmd>HopChar1CurrentLine<cr>", "[M] hop char in line" },
  ["<space>"] = { "<cmd>HopLineStart<cr>", "[M] hop to line" },
  s = { "<cmd>HopChar1AC<cr>", "[M] hop to next char" },
  S = { "<cmd>HopChar1BC<cr>", "[M] hop to prev char" },
}, vim.tbl_extend("force", opt, { mode = { "x", "n", "o" } }))

-- https://github.com/mhinz/vim-galore#quickly-move-current-line
--  FIX: error when target moves execeeds line range of file
vim.cmd [[
nnoremap <silent> <leader>[  :<c-u>execute "move -1-". v:count1<cr>
nnoremap <silent> <leader>]  :<c-u>execute "move +". v:count1<cr>
vnoremap <silent> <leader>[  :<c-u>execute "'<,'>move '<-1-". v:count1<cr>gv=gv
vnoremap <silent> <leader>]  :<c-u>execute "'<,'>move '>+". v:count1<cr>gv=gv
]]

wk.register({
  ["]"] = { "move line up", mode = { "n", "v" } },
  ["["] = { "move line down", mode = { "n", "v" } },
}, opt)

local process_yank = function()
  local yanked = vim.fn.getreg('+') -- I share system register (+) with vim
  yanked = vim.fn.substitute(yanked, "^ *", "", "")
  yanked = vim.fn.substitute(yanked, "\n$", "", "")
  vim.fn.setreg("+", yanked)
end
wk.register({
  p = { function()
    process_yank()
    vim.cmd [[normal o]]
    vim.cmd [[normal p]]
    vim.cmd "normal `[v`]" -- Select pasted text
    vim.lsp.buf.format { async = false }
    vim.cmd [[exe "normal! \<esc>"]]
  end, "p line-down and format" },
  P = { function()
    process_yank()
    vim.cmd [[normal O]]
    vim.cmd [[normal p]]
    vim.cmd "normal `[v`]" -- Select pasted text
    vim.lsp.buf.format { async = false }
    vim.cmd [[exe "normal! \<esc>"]]
  end, "p line-up and format" },
  ["<BS>"] = { "blank current line", mode = { "n", "v" } },
}, opt)

-- FIX: can not preserve every lines
vim.cmd [[
nnoremap <silent> <leader><BS> :<c-u>execute "normal ". v:count1 . "S"<cr>
vnoremap <silent> <leader><BS> :normal S<cr>
]]
