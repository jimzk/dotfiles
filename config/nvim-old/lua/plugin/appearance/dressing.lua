require('dressing').setup {
  input = {
    win_options = {
      winblend = 0,
    }
  },
  select = {
    backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
    telescope = require('telescope.themes').get_cursor({
      prompt_prefix = " ",
      initial_mode = "normal",
    }),
    builtin = {
      max_width = { 150, 0.9 },
      min_width = { 50, 0.25 },
      height = nil,
    }
  }
}
vim.cmd [[
au ColorScheme * hi! link NormalFloat Normal
]]
