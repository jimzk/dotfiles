local wk = require("which-key")
local ignored = "which_key_ignore"

-- https://github.com/folke/which-key.nvim/blob/main/lua/which-key/plugins/presets/init.lua
local objects = vim.tbl_extend("force", require("which-key.plugins.presets").objects, {
  ["iB"] = "}",
  ["aB"] = "}",
  ["ip"] = "Paragraph",
  ["ap"] = "Paragraph with Whitespace",
  ["iw"] = ignored,
  ["aw"] = ignored,
  ["iW"] = ignored,
  ["aW"] = ignored,
})
wk.register(objects, { mode = "o", prefix = "", preset = true })

-- https://github.com/folke/which-key.nvim/blob/main/lua/which-key/plugins/presets/misc.lua
local misc = {
  windows = {
    ["<c-w>"] = {
      name = "windows",
      s = "Split Window",
      v = "Split Window VerticAlly",
      q = "Close Window",
      o = "Close Other Windows",
      T = "Move Window to a New Tab",

      x = "Swap Current with Next",
      H = "Move Window to the Very Left (HJKL)",

      w = "Go to Next Windows",
      h = "Go to Left Window (hjkl)",
      p = "Go to Last Visited Window",

      ["-"] = "Decrease Height",
      ["+"] = "Increase Height",
      -- ["<lt>"] = "Decrease Width",
      -- [">"] = "Increase Width",

      ["|"] = "Max Out Width",
      ["_"] = "Max Out Height",
      ["="] = "Equal Windows",
    },
  },
  z = {
    ["z"] = {
      o = "Open Fold under Cursor",
      O = "Open All Folds under Cursor",
      c = "Close Fold under Cursor",
      C = "Close All Folds under Cursor",
      a = "Toggle Fold under Cursor",
      A = "Toggle All Folds under Cursor",
      v = "Show Cursor Line",
      M = "Close All Folds",
      R = "Open All Folds",
      m = "Fold More",
      r = "Fold Less",
      x = "Update Folds",

      ["<CR>"] = "👍Top this Line",
      t = "Top this Line",
      z = "Center this Line",
      b = "Bottom this Line",

      g = "Add Word to Spelling List",
      w = "Mark Word as Misspelling",
      -- e = "Right this Line",
      -- s = "Left this Line",
      H = "Half Screen to the left",
      L = "Half Screen to the right",
      i = "Toggle Folding",
      ["="] = "Spelling Suggestions",
    },
  },
  nav = {
    ["[{"] = "Prev {",
    ["]{"] = "Next {",
    ["[("] = "Prev (",
    ["]("] = "Next (",
    -- ["[<lt>"] = "Prev <",
    -- ["]<lt>"] = "Next <",
    ["[s"] = "Prev Misspelled Word",
    ["]s"] = "Next Misspelled Word",
  },
  g = {
    ["gf"] = "Go to File under Cursor",
    ["gx"] = "Open URL under Cursor",
    ["gi"] = "Insert in Last Insertion",
    ["gv"] = "VISUAL Last Selection",

    ["gn"] = "Search Forwards and Select",
    ["gN"] = "Search Backwards and Select",
    ["g%"] = "Cycle Backwards through results",
    -- ["gt"] = "Go to next tab page",
    -- ["gT"] = "Go to previous tab page",
  },
}

for _, mappings in pairs(misc) do
  wk.register(mappings, { mode = "n", prefix = "", preset = true })
end
