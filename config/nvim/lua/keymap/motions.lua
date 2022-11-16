
local motions = {
  ["%"] = "matching bracket",
  ["gn"] = "visual to next matched",
  ["gN"] = "visual to previous matched",
  ["{"] = "previous paragraph",
  ["}"] = "next paragraph",
  ["("] = "previous section",
  [")"] = "next section",
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
