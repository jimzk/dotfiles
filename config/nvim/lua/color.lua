vim.opt.cursorline = true
vim.opt.termguicolors = true

-- colorscheme
vim.g.everforest_background='soft'
vim.g.everforest_background='hard'
vim.cmd('colorscheme everforest')

-- highlight when yanking
vim.api.nvim_create_autocmd('TextYankPost',{
  callback = function()
    vim.highlight.on_yank {
      higroup = 'IncSearch',
      timeout = 300
    }
  end,
})

-- stand out visual area
vim.cmd("highlight clear Visual")
vim.cmd("highlight link Visual Search")
-- vim.cmd("highlight Visual gui=reverse guibg=NONE")
