local wk = require("which-key")
wk.register({
  ["H"] = "home (top) line of screen",
  ["M"] = "middle line of screen",
  ["L"] = "last line of screen",
  ["]"] = {
    name = "next object",
    [")"] = "next unmatched )",
    ["}"] = "next unmatched }",
    s = "next misspelled word",
  },
  ["["] = {
    name = "previous object",
    ["("] = "previous unmatched (",
    ["{"] = "previous unmatched {",
    s = "previous misspelled word",
  },
}, { mode = { "n", "o" }, prefix = "", preset = true })

wk.register({
  ["]%"] = "go to close item (matchup)",
  ["[%"] = "go to open item (matchup)",
  ["]b"] = { "<Plug>(matchup-]%)", "same as ]%" },
  ["[b"] = { "<Plug>(matchup-[%)", "same as [%" },
}, { mode = { "n", "o", "v" }, prefix = "", preset = true })

wk.register({
  ["]"] = {
    d = { "<cmd>:bnext<cr>", "next buffer" },
    t = { "<cmd>:tabnext<cr>", "next tab" },
    T = { "<cmd>:tablast", "last tab" },
    ["<C-t>"] = { "<cmd>tabm +1<cr>", "move tab right" },
    i = "peek next match of cursor word", -- builtin
    I = "peek all next match of cursor word",
    ["<C-i>"] = "go next match of cursor word",
    -- gitsigns
    c = "next Git change",
    -- todo-comments
    D = { function() require("todo-comments").jump_next() end, "next TODO" },
    v = { function() require('illuminate').goto_next_reference()
    end, "[C] next usage of variable" },
  },
  ["["] = {
    d = { "<cmd>:bprevious<cr>", "previous buffer" },
    t = { "<cmd>:tabprev<cr>", "previous tab" },
    T = { "<cmd>:tabfirst", "first tab" },
    ["<C-t>"] = { "<cmd>tabm -1<cr>", "move tab left" },
    i = "peek first match of cursor word", -- builtin
    I = "peek all match of cursor word",
    ["<C-i>"] = "go first match of cursor word",
    -- gitsigns
    c = "previous Git change",
    -- todo-comments
    D = { function() require("todo-comments").jump_prev() end, "previous TODO" },
    v = { function() require('illuminate').goto_prev_reference()
    end, "[C] previous usage of variable" },
  },
}, { mode = { "n" }, prefix = "", preset = true })
