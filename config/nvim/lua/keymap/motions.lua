require("which-key").register({
  ["%"] = "matching bracket",
  ["{"] = "previous paragraph",
  ["}"] = "next paragraph",
  ["("] = { "prev Git change", mode = "n" },
  [")"] = { "next Git change", mode = "n" },
  ["e"] = "next word end (opposite w)",
  ["ge"] = "previous word end (opposite b)",
}, { mode = { "n", "o", "v" }, prefix = "", preset = true })
