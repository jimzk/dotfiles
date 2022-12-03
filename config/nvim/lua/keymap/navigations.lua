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
  ["]%"] = "which_key_ignore", -- replaced by [b
  ["[%"] = "which_key_ignore", -- replaced by [b
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
    -- configured in minimal.vim
    e = { "move line up", mode = { "n", "v" } },
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
    -- configured in minimal.vim
    e = { "move line down", mode = { "n", "v" } },
    -- gitsigns
    c = "previous Git change",
    -- todo-comments
    D = { function() require("todo-comments").jump_prev() end, "previous TODO" },
    v = { function() require('illuminate').goto_prev_reference()
    end, "[C] previous usage of variable" },
  },
}, { mode = { "n" }, prefix = "", preset = true })

-- ]% -> ]b, [% -> [b
wk.register({
  ["[b"] = { "<Plug>(MatchitNormalMultiBackward)", "previous unmatched ( { [ or group", mode = "n" },
}, { preset = true })
wk.register({
  ["[b"] = { "<Plug>(MatchitVisualMultiBackward)", "previous unmatched ( { [ or group", mode = "v" },
}, { preset = true })
wk.register({
  ["[b"] = { "<Plug>(MatchitOperationMultiBackward)", "previous unmatched ( { [ or group", mode = "o" },
}, { preset = true })
wk.register({
  ["]b"] = { "<Plug>(MatchitNormalMultiForward)", "next unmatched ) } ] or group", mode = "n" },
}, { preset = true })
wk.register({
  ["]b"] = { "<Plug>(MatchitVisualMultiForward)", "next unmatched ) } ] or group", mode = "v" },
}, { preset = true })
wk.register({
  ["]b"] = { "<Plug>(MatchitOperationMultiForward)", "next unmatched ) } ] or group", mode = "o" },
}, { preset = true })
