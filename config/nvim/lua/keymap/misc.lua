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
  ["<C-h>"] = { "<C-w>h", "left window" },
  ["<C-j>"] = { "<C-w>j", "down window" },
  ["<C-k>"] = { "<C-w>k", "up window" },
  ["<C-l>"] = { "<C-w>l", "right window" },
  ["<C-g>"] = { "<C-w>p", "✭ go last accessed window" },
  ["<C-z>"] = { "<cmd>normal u<cr>", "undo", mode = { "i" } },
  ["<C-cr>"] = { ":noh<cr>", "clear search highlight" },
  -- tab
  ["<A-'>"] = { "<cmd>BufferScrollRight<cr>", "tab scroll right" },
  ["<A-;>"] = { "<cmd>BufferScrollLeft<cr>", "tab scroll left" },
  ["<A-.>"] = { "<cmd>BufferNext<cr>", "next tab" },
  ["<A-,>"] = { "<cmd>BufferPrev<cr>", "prev tab" },
  ["<A-/>"] = { "<cmd>BufferPick<cr>", "pick tab" },
  ["<A->>"] = { "<cmd>BufferMoveNext<cr>", "move tab right" },
  ["<A-<>"] = { "<cmd>BufferMovePrevious<cr>", "move tab left" },
  ["<A-p>"] = { "<cmd>BufferPin<cr>", "pin tab" },
}, opt)

wk.register({
  ["<S-cr>"] = { "<esc>o", "insert newline", mode = "i" }
}, opt)
wk.register({
  ["<S-cr>"] = { '<cmd>call append(line("."),   repeat([""], v:count1))<cr>', "insert newline", mode = "n" }
}, opt)

wk.register({
  -- mg979/vim-visual-multi
  ["<S-up>"] = { "<Plug>(VM-Select-Cursor-Up)", "visual up" },
  ["<S-down>"] = { "<Plug>(VM-Select-Cursor-Down)", "visual down" },
  ["<S-left>"] = "visual left",
  ["<S-right>"] = "visual right",
  ["<C-up>"] = "multi select up",
  ["<C-down>"] = "multi select down",
}, opt)

vim.keymap.set("c", "<C-space>", "<cr>")
