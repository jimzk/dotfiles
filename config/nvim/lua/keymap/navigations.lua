local wk = require("which-key")
local nav = {
  ["H"] = "home (top) line of screen",
  ["M"] = "middle line of screen",
  ["L"] = "last line of screen",
  ["]"] = {
    name = "next object",
    [")"] = "next unmatched )",
    ["}"] = "next unmatched }",
    s = "next misspelled word",
    c = "next git change",  -- gitsigns
    t = {function() require("todo-comments").jump_next() end, "next TODO"},
    l = {"move line up", mode = {"n", "v"}},
    v = {function ()
      require('illuminate').goto_next_reference()
    end, "next usage of variable"},
    ["%"] = "which_key_ignore",  -- replaced by ]b
  },
  ["["] = {
    name = "previous object",
    ["("] = "previous unmatched (",
    ["{"] = "previous unmatched {",
    s = "previous misspelled word",
    c = "previous git change",  -- gitsigns
    t = {function() require("todo-comments").jump_prev() end, "previous TODO"},
    l = {"move line down", mode = {"n", "v"}},
    v = {function ()
      require('illuminate').goto_prev_reference()
    end, "previous usage of variable"},
    ["%"] = "which_key_ignore",  -- replaced by [b
  },
}
wk.register(nav, { mode = {"n", "o"}, prefix = "", preset = true })

-- ]m -> ]f, ]M -> ]F
-- should use vim.keymap.set otherwise not working.
vim.keymap.set({"n", "o", "v"}, "]f", "]m")
vim.keymap.set({"n", "o", "v"}, "]F", "]M")
vim.keymap.set({"n", "o", "v"}, "[f", "[m")
vim.keymap.set({"n", "o", "v"}, "[F", "[M")
wk.register({
    ["[f"] = {"previous method start - [m", mode = {"n", "o", "v"}},
    ["[F"] = {"previous method end   - [M", mode = {"n", "o", "v"}},
    ["]f"] = {"next method start - ]m", mode = {"n", "o", "v"}},
    ["]F"] = {"next method end   - ]M", mode = {"n", "o", "v"}},
}, {mode = {"n", "o", "v", prefix = "", preset = true}})

-- ]% -> ]b, [% -> [b
wk.register({
  ["[b"] = {"<Plug>(MatchitNormalMultiBackward)", "previous unmatched ( { [ or group", mode = "n"},
}, { preset = true })
wk.register({
  ["[b"] = {"<Plug>(MatchitVisualMultiBackward)", "previous unmatched ( { [ or group", mode = "v"},
}, { preset = true })
wk.register({
  ["[b"] = {"<Plug>(MatchitOperationMultiBackward)", "previous unmatched ( { [ or group", mode = "o"},
}, { preset = true })
wk.register({
  ["]b"] = {"<Plug>(MatchitNormalMultiForward)", "next unmatched ) } ] or group", mode = "n"},
}, { preset = true })
wk.register({
  ["]b"] = {"<Plug>(MatchitVisualMultiForward)", "next unmatched ) } ] or group", mode = "v"},
}, { preset = true })
wk.register({
  ["]b"] = {"<Plug>(MatchitOperationMultiForward)", "next unmatched ) } ] or group", mode = "o"},
}, { preset = true })
