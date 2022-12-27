local wk = require("which-key")
local opt = { mode = "n", prefix = "g", preset = true }
wk.register({
  name = "go",
  ["%"] = { "cycle forward ) } ] or group", mode = { "n", "v", "o" } },
  a = "print ascii of cursor char",
  i = "✭ insert in last insertion (mark ^)",
  I = "✭ insert in current line start (0)",
  ["_"] = "✭ last non-blank char",
  m = "go half width of screen",
  M = "go half width of current line",
  v = "✭ visual last selection",
  n = "select next matched",
  N = "select previous matched",
  c = {
    name = "line comment",
    mode = { "n", "o" },
    c = "comment line",
    u = "uncomment block",
  },
  u = { "lowercase", mode = { "v", "o" } },
  U = { "uppercase", mode = { "v", "o" } },
  p = "paste before char ",
  [";"] = "which_key_ignore",
  [","] = "which_key_ignore",
  ["'"] = "go mark without changing jumplist",
  ["`"] = "which_key_ignore",
  ["<lt>"] = "display output of last command",
  ["<cr>"] = { "<cmd>Gitsigns preview_hunk<cr>", "[G] preview current change" },
  ["<C-g>"] = "display cursor position info",
  ["<C-o>"] = { function()
    require("telescope.builtin").treesitter({
      prompt_title = "Function Names, Variables and Symbols",
      results_title = "autocompletion menu ^l",
    })
  end, "[C] symbol outline (by treesitter)" },

  -- overwrite gt and gT
  t = { function()
    local d = vim.fn.expand("%:p")
    vim.cmd("TodoTrouble cwd=" .. d)
    vim.keymap.set("n", "gt", ":TroubleClose<cr>", { buffer = true, silent = true })
  end, "[C] TODOs" },
  T = { function()
    vim.cmd("TodoTrouble")
    vim.keymap.set("n", "gT", ":TroubleClose<cr>", { buffer = true, silent = true })
  end, "[C] TODOs in workspace" },
  ["<C-t>"] = { "<cmd>TodoTelescope<cr>", "[C] search TODOs" },
}, opt)

