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
  -- TODO: remap key: o pick(preview), O(auto preview) enter, <cr> enter, (<C-r> enter and close (unmap) not need)
  action_keys = {
    open_split = "s",
    open_vsplit = "v",
    preview = "o",
    toggle_preview = "O"
  }
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = { "Trouble" },
  callback = function()
    local trouble_opt = { skip_groups = true, jump = false }
    local opts = { buffer = true, silent = true }
    set("n", "j", function() trouble.next(trouble_opt); end, opts)
    set("n", "k", function() trouble.previous(trouble_opt); end, opts)
    set("n", "H", function() trouble.first(trouble_opt); end, opts)
    set("n", "L", function() trouble.last(trouble_opt); end, opts)
    set("n", "h", "", opts)
    set("n", "l", "", opts)
  end
})

-- A workaround to replace native quickfix and locallist
-- https://github.com/folke/trouble.nvim/issues/70
vim.api.nvim_create_autocmd('BufWinEnter', {
  pattern = { "quickfix" },
  callback = function()
    vim.defer_fn(function()
      vim.cmd('cclose')
      trouble.open('quickfix')
    end, 0)
  end
})
