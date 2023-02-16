return {
  -- Enhanced f/F/t/T motions. I only use it in normal and visual mode
  "ggandor/flit.nvim",
  dependencies = {
    "ggandor/leap.nvim",
  },
  event = "VeryLazy",
  opts = {
    labeled_modes = "vno",
    motion_specific_args = {
      o = {
        f = { offset = -1 },
        F = { offset = 1 },
      },
    }
  }
}
