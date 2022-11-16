local g = {
  name = "go",
  ["%"] = {"cycle forward ) } ] or group", mode = {"n", "v", "o"}},
  a = "print ascii value of char under cursor",
  f = "open file under cursor",
  i = "✭ insert in last insertion (mark ^)",
  I = "✭ insert in star (0) of current line",
  ["_"] = "✭ last non-blank char",
  m = "go half width of screen",
  M = "go half width of current line",
  v = "✭ visual last selection",
  c = {
    name = "line comment",
    mode = {"n", "o"},
    c = "comment line",
    u = "uncomment block",
  },
  u = {"lowercase", mode = {"v", "o"}},
  U = {"uppercase", mode = {"v", "o"}},
  p = "paste before char ",
  d = "definition under cursor",
  -- splitjoin
  J = "joins lines and keep leading spaces",
  S = "splits line by syntax",
  -- tab navigation
  ["<tab>"] = "go last accessed tab",
  [";"] = "which_key_ignore",
  [","] = "which_key_ignore",
  ["'"] = "go mark without changing jumplist",
  ["`"] = "which_key_ignore",
  ["<lt>"] = "display output of last command",

  ["<C-g>"] = "display current position info",

  ["<C-o>"] = {function() require("telescope.builtin").treesitter({
    prompt_title = "Function Names, Variables and Symbols",
    results_title = "autocompletion menu ^l",
  }) end, "[C] symbol search (by treesitter)"},

  -- overwrite gt and gT
  t = {function()
    local d = vim.fn.expand("%:p")
    vim.cmd("TodoTrouble cwd=" .. d)
    vim.keymap.set("n", "gt", ":TroubleClose<cr>", {buffer = true, silent = true})
  end, "[C] TODOs"},
  T = {function()
    vim.cmd("TodoTrouble")
    vim.keymap.set("n", "gT", ":TroubleClose<cr>", {buffer = true, silent = true})
  end, "[C] TODOs in workspace"},
  ["<C-t>"] = {"<cmd>TodoTelescope<cr>", "[C] search TODOs"},
}
require("which-key").register(g, { mode = "n", prefix = "g", preset = true })
