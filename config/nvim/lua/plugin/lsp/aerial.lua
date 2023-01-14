local aerial = require('aerial')
aerial.setup {
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    local opts = { buffer = bufnr }
    -- vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', opts)
    -- vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', opts)
  end,
  layout = {
    max_width = { 40, 0.3 },
    default_direction = "right",
  },
  keymaps = {
    ["g?"] = false,
    ["p"] = false,
    ["o"] = "actions.scroll",
    ["O"] = false,
    ["<C-j>"] = false,
    ["<C-k>"] = false,
    ["J"] = "actions.down_and_scroll",
    ["K"] = "actions.up_and_scroll",
  },
  highlight_mode = "full_width",
  highlight_on_hover = true,
  highlight_on_jump = 300,
  show_guides = true,
}

set('n', 'go', '<cmd>AerialToggle<CR>', { desc = "outline" })
