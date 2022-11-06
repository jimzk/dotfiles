local wk = require("which-key")

wk.setup {
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    -- disable most presets and set my customized keymap
    presets = {
      operators = true,
      motions = false,
      text_objects = false,
      windows = false,
      nav = false,
      z = false,
      g = false,
    },
  },
  -- add operators that will trigger motion and text object completion
  operators = {
    gc = "comment",  -- vim-commentary
    cx = "exchange",  -- vim-exchange
    ys = "add surrounding breackets or quotes"
  },
  window = {
    border = "single", -- none, single, double, shadow
  },
  layout = {
    height = { min = 5, max = 80 }, -- min and max height of the columns
  },
}

---------- start override preset keymap ----------
-- https://github.com/folke/which-key.nvim/blob/main/lua/which-key/plugins/presets/init.lua
local motions = {
  ["%"] = "matching bracket",
  ["gn"] = "select next matched",
  ["gN"] = "select previous matched",
  ["{"] = "previous empty line",
  ["}"] = "next empty line",
  -- search
  ["f"] = "move to next char",
  ["F"] = "move to previous char",
  ["t"] = "move before next char",
  ["T"] = "move before previous char",

  ["e"] = "next end of word (opposite w)",
  ["ge"] = "previous end of word (opposite b)",

  ["/"] = "search"
}
wk.register(motions, { mode = "n", prefix = "", preset = true })
wk.register(motions, { mode = "o", prefix = "", preset = true })

local objects = {
  ["a"] = {
    name = "around",
    ['"'] = [["..."]],
    ["'"] = [['...']],
    ["`"] = [[`...`]],
    ["("] = [[(...)]],
    ["{"] = [[{...}]],
    ["["] = "[...]",
    ["t"] = [[tag block (with whitespace)]],
    ["<lt>"] = [[<...>]],
    ["b"] = "any bracket",
    ["B"] = [[same as a{]],
    ["w"] = [[word (with whitespace)]],
    ["W"] = [[WORD (with whitespace)]],
    ["p"] = [[paragraph (with whitespace)]],
    ["s"] = [[sentence (with whitespace)]],
    -- target.vim
    ["a"] = [[argument]],
    ["q"] = [['...' or "..."]],
    ["l"] = {
      name = "previous object",
      ["B"] = [[same as a{]],
    },
    ["n"] = {
      name = "next object",
      ["B"] = [[same as a{]],
    },
    -- vim-indent-object
    ["i"] = [[indent content and line above]],
    ["I"] = [[indent content and line above/below]],
      --- vim-matchup
    ["%"] = "any bracket or ifelse block",
    -- vim-textobj-entire
    ["e"] = [[entire content of current buffer]]
  },
  ["i"] = {
    name = "inside",
    ['"'] = [[inner "..."]],
    ["'"] = [[inner '...']],
    ["`"] = [[inner `...`]],
    ["("] = [[inner (...)]],
    ["{"] = [[inner {...}]],
    ["["] = "inner [...]",
    ["<lt>"] = [[inner <...>]],
    ["t"] = [[inner tag block]],
    ["b"] = "inner any bracket",
    ["B"] = [[same as i{]],
    ["w"] = [[inner word]],
    ["W"] = [[inner WORD]],
    ["p"] = [[inner paragraph]],
    ["s"] = [[inner sentence]],
    -- target.vim
    ["a"] = [[argument]],
    ["q"] = [[inner '...', "..." or `...`]],
    ["l"] = {
      name = "previous object",
      ["B"] = [[same as i{]],
    },
    ["n"] = {
      name = "next object",
      ["B"] = [[same as i{]],
    },
    -- vim-indent-object
    ["i"] = [[inner indent content (no line above)]],
    ["I"] = [[inner indent content (no line above/below)]],
    --- vim-matchup
    ["%"] = "inner any bracket or ifelse block",
    -- vim-textobj-entire
    ["e"] = [[entire content without surrounding empty linesof current buffer]]
  },
    -- target.vim
    ["A"] = {
    name = "around with trailing spaces",
    ['"'] = [["..."]],
    ["'"] = [['...']],
    ["`"] = [[`...`]],
    ["("] = [[(...)]],
    ["{"] = [[{...}]],
    ["["] = "[...]",
    ["<lt>"] = [[<...>]],
    ["t"] = [[tag block (with whitespace)]],
    ["b"] = "any bracket",
    ["B"] = [[same as A{]],

    ["a"] = [[argument]],
    ["q"] = [['...' or "..."]],
    ["l"] = {
      name = "previous object",
      ["B"] = [[same as A{]],
    },
    ["n"] = {
      name = "next object",
      ["B"] = [[same as A{]],
    }
  },
  ["I"] = {
    name = [[inside with surrounding spaces]],
    ['"'] = [[inner "..."]],
    ["'"] = [[inner '...']],
    ["`"] = [[inner `...`]],
    ["("] = [[inner (...)]],
    ["{"] = [[inner {...}]],
    ["["] = "inner [...]",
    ["<lt>"] = [[inner <...>]],
    ["t"] = [[inner tag block]],
    ["b"] = "inner any bracket",
    ["B"] = [[same as I{]],

    ["a"] = [[argument]],
    ["q"] = [[inner '...', "..." or `...`]],
    ["l"] = {
      name = "previous object",
      ["B"] = [[same as I{]],
    },
    ["n"] = {
      name = "next object",
      ["B"] = [[same as I{]],
    }
  },
}
for k, v in pairs(objects['I']) do
  if k ~= "name" and k ~= "n" and k ~= "l" then
    if k ~= 'B' then
      objects['i']["l"][k] = "previous " .. v
      objects["i"]["n"][k] = "next " .. v
      objects['I']['l'][k] = "previous " .. v
      objects['I']['n'][k] = "next " .. v
    end
  end
end
for k, v in pairs(objects['A']) do
  if k ~= "name" and k ~= "n" and k ~= "l" then
    if k ~= 'B' then
      objects['a']["l"][k] = "previous " .. v
      objects['a']['n'][k] = "next " .. v
      objects['A']['l'][k] = "previous " .. v
      objects['A']['n'][k] = "next " .. v
    end
  end
end
wk.register(objects, { mode = "o", prefix = "", preset = true })

local  windows = {
  name = "window",
  s = "new split window",
  v = "new split window vertically",
  w = "switch window",
  q = "quit window",
  T = "break window into a new tab",
  x = "swap current with next",
  ["-"] = "decrease height",
  ["+"] = "increase height",
  ["<lt>"] = "decrease width",
  [">"] = "increase width",
  ["|"] = "max out the width",
  ["_"] = "max out the height",
  ["="] = "equally high and wide",
  h = "go to left window (hjkl)",
  H = "move window to most left (HJKL)",
  -- l = "go to right window",
  -- k = "go to up window",
  -- j = "go to down window",
  n = "new buffer in new window",
  ["^"] = "open alternate buffer (#) in new window",
  o = "close other windows",
}
wk.register(windows, { mode = "n", prefix = "<c-w>", preset = true })

local nav = {
  ["H"] = "home (top) line of screen",
  ["M"] = "middle line of screen",
  ["L"] = "last line of screen",
  ["]"] = {
    name = "next object",
    [")"] = "next )",
    ["}"] = "next }",
    [">"] = "next >",
    ["%"] = "next ), } or ]",
    m = "next method start",
    M = "next method end",
    s = "next misspelled word",
    c = "next git change",  -- gitsigns
  },
  ["["] = {
    name = "previous object",
    ["("] = "previous (",
    ["{"] = "previous {",
    ["<lt>"] = "previous <",
    ["%"] = "previous (, { or [",
    m = "previous method start",
    M = "previous method end",
    s = "previous misspelled word",
    c = "previous git change",  -- gitsigns
  }
}
wk.register(nav, { mode = "n", prefix = "", preset = true })
wk.register(nav, { mode = "o", prefix = "", preset = true })

local g = {
  ["%"] = {"cycle through brackets", mode = {"n", "v", "o"}},
  f = "go to file under cursor",
  x = "open the file under cursor with system app",
  i = "insert in last insertion (mark ^)",
  I = "insert in star of last insertion",
  v = "visual last selection",
  c = {
    name = "line comment",
    mode = {"n", "v", "o"},
    c = "comment line",
    u = "uncomment block",
  },
  u = "lowercase",
  U = "uppercase",
  J = "joins lines and keep leading spaces",
  S = "splits line by syntax",
  p = "paste before char ",
  d = "go to definition under cursor",
  t = "next tab",
  T = "previous tab",
  ["<tab>"] = "latest tab",
  [";"] = "go to older change position",
  [","] = "go to newer change position",
  ["'"] = "go to mark without changing jumplist",
  ["`"] = "which_key_ignore",
}
wk.register(g, { mode = "n", prefix = "g", preset = true })

local z = {
  -- fold
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
}
wk.register(z, { mode = "n", prefix = "z", preset = true })
---------- end override preset keymap ----------

local leader = {
  ["]"] = "add empty line bewlow",
  ["["] = "add empty line above",
  ["`"] = "last active tab",
  w = {"camelCase w", mode = {"n", "v", "o"}},
  b = {"camelCase b", mode = {"n", "v", "o"}},
  e = {"camelCase e", mode = {"n", "v", "o"}},
  ["ge"] = {"camelCase ge", mode = {"n", "v", "o"}},
  s = {
    name = "buffer",
    d = {"<cmd>bd<cr>", "delete current buffer (not close window)"},
    n = {"<cmd>edit<cr>", "new buffer"},
    e = {"<cmd>!open %<cr>", "open buffer by default appcalition"},
  },
  g = {
    name = "git",
    -- gitsigns
    S = {"<cmd>Gitsigns stage_buffer<cr>", "stage current buffer"},
    s = {"<cmd>Gitsigns stage_hunk<cr>", "stage change", mode = {"n", "v"}},
    x = {"<cmd>Gitsigns undo_stage_hunk<cr>", "unstage change"},
    U = {"<cmd>Gitsigns reset_buffer<cr>", "revert buffer"},
    u = {"<cmd>Gitsigns reset_hunk<cr>", "revert change", mode = {"n", "v"}},
    p = {"<cmd>Gitsigns preview_hunk<cr>", "preview change"},
    P = {"<cmd>Gitsigns toggle_deleted<cr><cmd>Gitsigns toggle_linehl<cr>", "preview all changes (toggle)"},
    b = {"<cmd>lua require('gitsigns').blame_line{full=true}<cr>", "inline blame"},
    d = {"<cmd>Gitsigns diffthis<cr>", "diff"},
    -- fugitive
    B = {"<cmd>Git blame<cr><cmd>echo '[git blame] g? for help'<cr>", "file blame"},
    g = {"<cmd>Git<cr>", "git status"},
  },
  j = {
    name = "jump",
    j = {"g<tab>", "last tab"},
    p = {"gT", "previous tab"},
    n = {"gt", "next tab"},
  },
  ["\\"] = {
    name = "vimer",
    -- Telescope
    h = {"<cmd>Telescope help_tags<cr>", "list help keywords (tags)"},
    c = {"<cmd>Telescope commands<cr>", "list avaliable commands"},
    C = {"<cmd>Telescope command_history<cr>", "list command history"},
    r = {"<cmd>Telescope colorscheme enable_preview=true<cr>", "list avaliable colorschemes"},
    m = {"<cmd>Telescope keymaps<cr>", "list keymaps in all modes"},
    o = {"<cmd>Telescope vim_options<cr>", "list Vim options"},
    l = {"<cmd>Telescope highlights<cr>", "list highlights"},
    a = {"<cmd>Telescope autocommands<cr>", "list autocommands"},
    w = {"<cmd>Telescope loclist<cr>", "list locations in current window"},
    v = {"<cmd>source $MYVIMRC<cr><cmd>runtime! plugin/**/*.vim plugin/**/*.lua<cr>", "reload vim configurations"},
    ["\\"] = {
      name = "cheatsheet",
      m = {
        name = "mark",
        ["1"] = {"set mark 1"},
        ["a"] = {"set mark a"},
        ["A"] = {"set mark A (across buffers)"},
        [";"] = {"preview mark (then press a or <cr>)"},
        ["]"] = {"move to next mark"},
        ["["] = {"move to previous mark"},
        ["-"] = {"delete current marks"},
      }
    }
  }
}
wk.register(leader, {prefix = "<leader>"})
vim.keymap.set("n", "m-", "<cmd>lua require'marks'.delete_line()<cr>")

wk.register({
  -- rename
  j = "which_key_ignore",
  k = "which_key_ignore",
  d = {
    name = "delete",
    s = {
      name = "surrounding",
      ['"'] = [[delete ""]],
      ['('] = "delete () and remove inner spaces",
      [')'] = "delete ()",
    }
  },
  y = {
    name = "copy",
    s = {
      s = "yss) add () to entire line",
    }
  },
  Y = {"yank entire line"},
  U = {"redo"},
  ["<C-y>"] = {"scroll up"},
  ["<C-e"] = {"scroll down"},
  -- vim-expand-region
  ["+"] = "expand selection",
  ["_"] = "shrink selection",
  v = {
    name = "visual",
    ["+"] = {"expand selection"},
    ["_"] = {"shrink selection"},
  },
  c = {
    name = "change",
    l = "detele currnt char",
    x = {
      name = "exchange text",
      x = "exchange line",
      c = "clear exchange",
    },
    s = {
      name = "replace surrounding",
      ['"'] = [[cs"' replaces "" with '']],
      ['('] = "cs([ replace () with [] ",
      [')'] = "cs)[ replace () with [] and remove inner spaces",
    },
    S = [[cS"' replaces "" with '' and new line]],
  },
  -- gitsigns
  ["ih"] = {"<cmd>Gitsigns select_hunk<cr>", "select git change", mode = {"o", "v"}},
  -- window
  ["<c-w>"] = {
    N = {"<cmd>enew<cr>", "new buffer in current window"},
    Q = {"<cmd>q!<cr>", "quit window forcely"},
  },
  -- matchup
  ["z%"] = {"go to nearest (, { or [", mode = {"o", "n", "v"}},
  ["[e"] = {"move line up", mode = "n"},
  ["]e"] = {"move line down", mode = "n"},
})

-- marks.nvim
wk.register({
  d = {
    m = {
      name = "delete bookmark",
      ["1"] = "delete mark 1",
      ["a"] = "delete mark a",
      ["A"] = "delete mark A",
      ["<space>"] = "delete marks in cursor line",
      ["-"] = "delete all marks in current buffer",
    },
  },
})
