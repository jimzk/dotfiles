require("toggleterm").setup {
  open_mapping = [[<M-space>]],
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  direction = "float", -- 'vertical' | 'horizontal' | 'tab' | 'float'
  float_opts = {
    winblend = 20,
    width = 140,
    border = 'single', -- 'single' | 'double' | 'shadow' | 'curved'
  },
  -- https://github.com/akinsho/toggleterm.nvim#terminal-window-mappings
  on_open = function(_)
    local opts = { buffer = true, noremap = true }
    if vim.fn.exists("g:neovide") == 1 then
      vim.cmd [[
tnoremap <special> <D-v> <C-\><C-n>pal<BS>
]]
    end
  end
}
require("which-key").register({
  ["<M-space>"] = "toggle terminal"
})
-- TODO: integrate lazygit
-- https://github.com/akinsho/toggleterm.nvim#custom-terminals

-- TODO: copy / paste with toggle terminal
-- ref: https://github.com/akinsho/toggleterm.nvim/pull/339
