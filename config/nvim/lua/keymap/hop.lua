local wk = require("which-key")
wk.register({
  [","] = {
    [","] = { "<cmd>HopWordAC<cr>", "hop to next word" },
    ["."] = { "<cmd>HopWordBC<cr>", "hop to prev word" },
    h = { "<cmd>HopWordCurrentLineBC<cr>", "hop to prev word in current line" },
    l = { "<cmd>HopWordCurrentLineAC<cr>", "hop to next word in current line" },
    f = { "<cmd>HopChar1AC<cr>", "hop to next char" },
    F = { "<cmd>HopChar1BC<cr>", "hop to prev char" },
    a = { "<cmd>HopLineStart<cr>", "hop to line" },
    ["<cr>"] = {
      name = "cross windows",
      [","] = { "<cmd>HopWordACWM<cr>", "hop to next word" },
      ["."] = { "<cmd>HopWordBCWM<cr>", "hop to prev word" },
      h = { "<cmd>HopWordCurrentLineBCWM<cr>", "hop to prev word in current line" },
      l = { "<cmd>HopWordCurrentLineACWM<cr>", "hop to next word in current line" },
      f = { "<cmd>HopChar1ACWM<cr>", "hop to next char" },
      F = { "<cmd>HopChar1BCWM<cr>", "hop to prev char" },
      a = { "<cmd>HopLineStartWM<cr>", "hop to line" },
    }
  }
})
