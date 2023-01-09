local trouble = require("trouble")
trouble.setup {
  position = "bottom",
  height = 15,
  padding = false,
  -- FIX: can't jump back after selecting items
  -- https://github.com/folke/trouble.nvim/issues/143#issuecomment-1281771551 is a workaround
  -- https://github.com/folke/trouble.nvim/issues/235
  auto_jump = { "lsp_definitions", "lsp_type_definitions", "lsp_implementations" },
  auto_preview = false,
  -- actions list: https://github.com/folke/trouble.nvim/blob/main/lua/trouble/init.lua#L157
  action_keys = {
    open_split = "s",
    open_vsplit = "v",
    toggle_preview = "p",
    preview = "l",
    help = "?",
    jump = "<cr>",
  }
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = { "Trouble" },
  callback = function()
    local trouble_opt = { skip_groups = true, jump = false }
    local opts = { noremap = true, buffer = true, silent = true }
    set("n", "J", function() trouble.next(trouble_opt) end, opts)
    set("n", "K", function() trouble.previous(trouble_opt) end, opts)
    -- set("n", "H", function() trouble.first(trouble_opt); end, opts)
    -- set("n", "L", function() trouble.last(trouble_opt); end, opts)
  end
})

-- A workaround to replace native quickfix and locallist
-- https://github.com/folke/trouble.nvim/issues/70
-- vim.api.nvim_create_autocmd('BufWinEnter', {
--   pattern = { "quickfix" },
--   callback = function()
--     vim.defer_fn(function()
--       vim.cmd('cclose')
--       trouble.open('quickfix')
--     end, 0)
--   end
-- })
