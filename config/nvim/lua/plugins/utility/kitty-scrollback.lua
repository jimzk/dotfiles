return {
  -- Useage:
  -- * <C-S-h> (Mine is shift+cmd+b) toggle kitty-scrollback for all content in terminal screent
  -- * <C-S-g> (Mine is cmd+b) toggle kitty-scrollback for last command output
  -- See more: https://github.com/mikesmithgh/kitty-scrollback.nvim#-features
  "mikesmithgh/kitty-scrollback.nvim",
  enabled = false,
  lazy = true,
  cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
  event = { "User KittyScrollbackLaunch" },
  opts = {},
  config = function(_, opts)
    require("kitty-scrollback").setup(opts)

    vim.api.nvim_create_autocmd({ "FileType" }, {
      group = vim.api.nvim_create_augroup("KittyScrollbackNvimFileType", { clear = true }),
      pattern = { "kitty-scrollback" },
      callback = function(callback_opts)
        vim.keymap.set("n", "q", "<cmd>q<CR>", { buffer = callback_opts.bufnr })
        return true
      end,
    })
  end,
}
