local wk = require("which-key")
local ignored_keys = { "&", "Y", "y", "d", "D", "v", "m", "J", "f", "F", "t", "T", "w", "b", "e", "ge" }
for _, key in ipairs(ignored_keys) do
  wk.register({ [key] = "which_key_ignore" })
end
local opts = { mode = "n", prefix = "g", preset = true }
wk.register({
  name = "+go",
  a = "print ascii of cursor char",
  i = "✭ insert in last insertion (mark ^)",
  ["_"] = "✭ last non-blank char",
  m = "go half width of screen",
  M = "go half width of current line",
  v = "✭ visual last selection",
  n = "select next matched",
  N = "select previous matched",
  c = "comment",
  u = { "lowercase", mode = { "v", "o" } },
  U = { "uppercase", mode = { "v", "o" } },
  ["'"] = "go mark without changing jumplist",
  ["<lt>"] = { "display output of last command", mode = "n" },
  ["<C-g>"] = { "display cursor position info", mode = "n" },
}, opts)

opts = { mode = { "n", "o" }, preset = true }
wk.register({
  ["]"] = {
    name = "next object",
    [")"] = "next unmatched )",
    ["}"] = "next unmatched }",
    s = "next misspelled word",
    ["`"] = "next mark",
    I = "peek all next match of cursor word",
    ["<C-i>"] = "go next match of cursor word",
  },
  ["["] = {
    name = "prev object",
    ["("] = "prev unmatched (",
    ["{"] = "prev unmatched {",
    s = "prev misspelled word",
    ["`"] = "prev mark",
    I = { "peek all match of cursor word", mode = "n" },
    ["<C-i>"] = { "go first match of cursor word", mode = "n" },
  },
}, opts)

opts = { mode = "o", preset = true }
local textobj = {
  -- ['"'] = [["..."]],
  -- ["'"] = [['...']],
  -- ["`"] = [[`...`]],
  -- ["("] = [[(...)]],
  -- ["{"] = [[{...}]],
  -- ["["] = "[...]",
  -- ["<lt>"] = [[<...>]],
  ["t"] = [[tag block]],
  ["B"] = [[{}]],
  ["w"] = [[word]],
  ["W"] = [[WORD]],
  ["p"] = [[paragraph]],
  -- ["s"] = [[sentence]],
  -- mini-ai
  -- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-ai.md
  ["a"] = [[argument]],
  ["q"] = [[quotes ('' "" or ``)]],
  ["N"] = "prev object",
  ["n"] = "next object",
  [","] = ",...,",
  -- ["<Space>"] = "between whitespaces",
}

wk.register(vim.tbl_extend("force", textobj, { name = "+around" }), { mode = "o", prefix = "a" })
wk.register(vim.tbl_extend("force", textobj, { name = "+inside" }), { mode = "o", prefix = "i" })

opts = { mode = "n", prefix = "<c-w>", preset = true }
wk.register({
  name = "+window",
  -- new
  s = "split window",
  v = "split window vertically",
  n = "new buffer and split",
  N = { "<cmd>enew<cr>", "new buffer" },
  T = {
    function()
      local pos = vim.api.nvim_win_get_cursor(0)
      vim.cmd([[tabnew %]])
      vim.api.nvim_win_set_cursor(0, pos)
    end,
    "break window into new tab",
  },
  f = "split file under cursor (see gf)",
  -- navigation
  ["^"] = "split alternative buffer #",
  w = "go next window",
  p = "✭ go last accessed window",
  h = "(hjkl) go left window",
  t = { "go top window" },
  b = { "go bottom window" },
  -- preview navigation
  P = { "go preview window" },
  z = { "close preview window" },
  -- close
  o = "close other windows",
  c = "close window",
  -- layout
  r = { "rotate window layout" }, -- useless, can be removed in the future
  H = "(HJKL) move window to most left",
  x = "swap current window with next",
  ["-"] = "decrease height",
  ["+"] = "increase height",
  -- ["<lt>"] = "decrease width",
  -- [">"] = "increase width",

  ["<C-=>"] = { "<cmd>wincmd =<cr>", "equally size" },
  ["<C-->"] = { "<cmd>wincmd |<cr>", "max out height" },
  ["<C-\\>"] = { "<cmd>wincmd _<cr>", "max out width" },
  -- coding (not much useful)
  d = { "go definition under cursor and split" },
  i = { "go declaration under cursor and split" },
}, opts)

opts = { prefix = "<leader>,", silent = true }
wk.register({
  -- cheatsheet only for preview
  name = "+cheatsheet",
  b = { "<cmd>h :unlisted-buffer<cr>", "meaning of buffer status" },
  k = { "<cmd>h map-table<cr>", "mapping type" },
  t = { "<cmd>!open https://github.com/nvim-telescope/telescope-fzf-native.nvim<cr>", "telescope search syntax" },
  v = { "<cmd>!open https://github.com/mg979/vim-visual-multi<cr>", "multi select guide" },
  d = {
    name = "+how to read doc",
    ["0"] = { "CTRL ] go tag" },
    ["1"] = { "CTRL-O or CTRL-T go back" },
    ["2"] = { "CTRL-T go forward" },
    ["3"] = { "gO shows outline" },
    ["7"] = { "CTRL-W f split file under cursor" },
    ["8"] = { "CTRL-W ] split tag under cursor" },
    ["9"] = { "CTRL-] go tag" },

    ["a"] = { "CTRL-W } open tag in preview window" },
    ["b"] = { "CTRL-W P go preview window" },
    ["c"] = { "CTRL-W z close preview window" },

    ["A"] = { ":h :put documentation for :put" },
  },
  ["0"] = {
    name = "+efficiency",
    ["0"] = "_/g_ replace ^/$",
    ["1"] = "-/+ replace j/k",
    ["2"] = "gi re-insert, gv re-select",
    ["3"] = "<C-w>p go to latest window",
    ["4"] = "viq select current/next quotes content",
    ["5"] = "cina jump and delete next argument",
    ["6"] = "<leader>r resumes last telescope",
    ["7"] = "paragraph is the content between two blanklines",
  },
  ["1"] = {
    name = "+useful commands (range)",
    ["0"] = { "[range]{cmd}[x] basic form" },
    ["1"] = { ":5,10m2 move L#5~10 after L#2" },
    ["2"] = { ":5,10m$ move after file end" },
    ["3"] = { ":5,10m. move after current line" },
    ["4"] = { ":5,10m.+3 move after current L#+3" },
    ["5"] = { ":5,10m'a move after mark a" },
    ["6"] = { "similar commands: :y :d :t :j :p" },
    ["7"] = { ":put % write content in register % under cursor" },
    ["8"] = { ":put=execute('!ls') write command result under cursor" },
    ["9"] = { ":10r!ls write command result under L#10" },
    ["!"] = { ":5,10norm {cmd} execute command on L#5~10" },

    ["a"] = { ":1,10w !sh execute shell code in L#1~10" },
    ["b"] = { ":1,10w !sh execute shell code and replace" },
    ["c"] = { ":w !sudo tee% write file by sudo" },
    ["d"] = { ":1,10!sort sort L#1~10 and replace" },
    ["e"] = { ":1,10!python3 execute python code" },
  },
  ["2"] = {
    name = "+useful commands",
    ["0"] = { ":0file", "remove current file name" },
  },
}, opts)

opts = { prefix = "z", silent = true }
wk.register({
  name = "+fold/locate/spelling",
  o = "unfold",
  O = "unfold recursively",
  c = "fold",
  C = "fold recursively",
  a = "toggle fold",
  A = "toggle fold recursively",
  v = "show cursor line",
  M = "fold all",
  R = "unfold all",
  m = "fold more",
  r = "fold less",
  x = "update folds",
  -- locate
  z = "center cursor line",
  t = "top cursor line",
  b = "bottom cursor line",
  e = "scroll right",
  s = "scroll left",
  H = "half screen to the left",
  L = "half screen to the right",
  -- spelling
  g = "add word to spell list",
  w = "mark word as misspelling",
  ["="] = "spelling suggestions",
}, opts)
