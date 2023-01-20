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
    ["`"] = "next mark",
  },
  ["["] = {
    name = "prev object",
    ["("] = "prev unmatched (",
    ["{"] = "prev unmatched {",
    s = "prev misspelled word",
    ["`"] = "prev mark",
  },
}, { mode = { "n", "o" }, prefix = "", preset = true })

local mini_ai = require("mini.ai")
local mini_indent = require("mini.indentscope")
wk.register({
  ["]"] = {
    i = { function() mini_indent.move_cursor("bottom", false, {}) end, "indent content bottom" },
    ["a"] = { function()
      mini_ai.move_cursor("left", "i", "a", { search_method = "next" })
    end, "next parameter" },
  },
  ["["] = {
    i = { function() mini_indent.move_cursor("top", false, {}) end, "indent content top" },
    ["a"] = { function()
      mini_ai.move_cursor("left", "i", "a", { search_method = "prev" })
    end, "prev parameter" },
  },
}, { mode = { "n", "o", "v" }, prefix = "", preset = true })

wk.register({
  ["]"] = {
    I = "peek all next match of cursor word", -- builtin
    ["<C-i>"] = "go next match of cursor word",
    -- gitsigns
    ["<cr>"] = "next Git change",
    -- todo-comments
    t = { function() require("todo-comments").jump_next() end, "next TODO" },
    v = { function() require('illuminate').goto_next_reference()
    end, "[C] next variable usage" },
  },
  ["["] = {
    I = "peek all match of cursor word", -- builtin
    ["<C-i>"] = "go first match of cursor word",
    -- gitsigns
    ["<cr>"] = "prev Git change",
    -- todo-comments
    t = { function() require("todo-comments").jump_prev() end, "prev TODO" },
    v = { function() require('illuminate').goto_prev_reference()
    end, "[C] prev variable usage" },
  },
}, { mode = { "n" }, prefix = "", preset = true })
