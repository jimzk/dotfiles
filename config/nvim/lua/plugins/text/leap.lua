-- easily jump to any location and enhanced f/t motions for Leap
return {
  "ggandor/leap.nvim",
  keys = {
    { "f", "<Plug>(leap-forward-to)", mode = { "n", "x" } },
    { "F", "<Plug>(leap-backward-to)", mode = { "n", "x" } },
    { "f", "<Plug>(leap-forward-till)", mode = { "o" } },
    { "F", "<Plug>(leap-backward-till)", mode = { "o" } },
  },
  config = true,
}
