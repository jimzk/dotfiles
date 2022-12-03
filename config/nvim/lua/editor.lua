vim.o.relativenumber = true

-- https://vi.stackexchange.com/questions/4493/what-is-the-order-of-winenter-bufenter-bufread-syntax-filetype-events
-- Example: vim.cmd [[autocmd BufEnter * lua vim.notify('foo bar')]]
-- Easy quit
vim.api.nvim_create_autocmd('FileType', {
  pattern = { "help", "gitcommit", "quickfix", "fugitive", "fugitiveblame", "symbols-outline", "nvim-dap-ui",
    "lspsagaoutline", "qf", "spectre_panel", "Trouble", "calltree" },
  callback = function()
    vim.keymap.set("n", "q", function()
      vim.cmd [[q]]
      if vim.bo.filetype == "NvimTree" then -- not jump back to nvim-tree
        vim.cmd [[wincmd p]]
      end
    end, { buffer = true, silent = true })
  end
})

-- vim.cmd [[autocmd VimEnter * :clearjumps]]
