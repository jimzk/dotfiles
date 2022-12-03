local wk = require("which-key")
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
wk.register(motions, { mode = "n", prefix = "", preset = true })
wk.register(motions, { mode = "o", prefix = "", preset = true })

-- ,d black hole, d_ to first
for _, key in pairs({ "d", "c", "v", "y" }) do
  vim.keymap.set("n", key .. "_", key .. "^", { noremap = true })
  vim.keymap.set("n", key .. "g_", key .. "$", { noremap = true })
  wk.register({
    [key] = {
      ["_"] = "which_key_ignore",
      ["g_"] = "which_key_ignore",
    },
    ["," .. key] = { '"_' .. key, "black hole " .. key, mode = { "n", "v" } },
  }, { noremap = true })
end
wk.register({
  [",D"] = { '"_D', "black hole D" },
  [",C"] = { '"_C', "black hole C" },
}, { mode = { "n", "v" }, noremap = true })
