require('dressing').setup {
  input = {
    win_options = {
      winblend = 0,
    }
  },
  select = {
    telescope = require('telescope.themes').get_cursor(),
  }
}
vim.cmd [[
au ColorScheme * hi! link NormalFloat Normal
]]
