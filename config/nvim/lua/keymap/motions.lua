local wk = require("which-key")
local motions = {
  ["%"] = "matching bracket",
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
wk.register(motions, { mode = "n", prefix = "", preset = true })
wk.register(motions, { mode = "o", prefix = "", preset = true })
