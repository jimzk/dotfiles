
local leader_n = {
  name = "explorer",
  n = {"<cmd>NvimTreeToggle<cr>", "open file explorer"},
  N = {"<cmd>NvimTreeFindFile!<cr>", "open file explorer and locate"},
}

require("which-key").register(leader_n, { mode = "n", prefix = "<leader>n", preset = true })
