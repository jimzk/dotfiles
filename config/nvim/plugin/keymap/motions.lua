
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
require("which-key").register(motions, { mode = "n", prefix = "", preset = true })
require("which-key").register(motions, { mode = "o", prefix = "", preset = true })
