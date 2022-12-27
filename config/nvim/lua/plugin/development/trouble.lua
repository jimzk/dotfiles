require("trouble").setup {
  position = "bottom",
  height = 15,
  padding = false,
  -- FIX: can't jump back after selecting items
  -- https://github.com/folke/trouble.nvim/issues/143#issuecomment-1281771551 is a workaround
  -- https://github.com/folke/trouble.nvim/issues/235
  auto_jump = { "lsp_definitions", "lsp_type_definitions", "lsp_implementations" },
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = { "Trouble" },
  callback = function()
    local trouble = require("trouble")
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
