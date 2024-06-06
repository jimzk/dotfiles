local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("config.vscode")
require("lazy").setup({
  spec = {
    { import = "plugins.text.nvim-treesitter" },
    { import = "plugins.text.nvim-surround" },
    { import = "plugins.text.spider" },
    -- { import = "plugins.text.dial" },
    { import = "plugins.text.mini-ai" },
    { import = "plugins.text.mini-operators" },
    { import = "plugins.text.nvim-treesitter-textobjects" },
    { import = "plugins.text.nvim-various-textobjs" },
    { import = "plugins.text.treesj" },
    { import = "plugins.text.vim-textobj-user" },
    { import = "plugins.editor.gx" },
    { import = "plugins.text.yanky" },
    {
      "folke/flash.nvim",
      event = "VeryLazy",
      keys = {
        {
          "R",
          mode = { "o" },
          function()
            require("flash").remote()
          end,
          desc = "Remote (Flash)",
        },
        {
          "r",
          mode = { "o", "x" },
          function()
            require("flash").treesitter_search({
              label = { rainbow = { enabled = true } },
            })
          end,
          desc = "Treesitter Search (Flash)",
        },
        {
          "<CR>",
          mode = { "n", "o", "x" },
          function()
            require("flash").treesitter({
              label = { rainbow = { enabled = true } },
            })
          end,
          desc = "Treesitter Scope (Flash)",
        },
      },
      opts = {
        modes = {
          search = {
            enabled = true,
          },
          char = {
            enabled = true,
            keys = { "f", "F" },
            -- autohide = true,
            jump_labels = true,
            label = {
              exclude = "hjkliardcAZTU",
              rainbow = {
                enabled = false,
              },
            },
          },
        },
      },
    },

    -- { import = "plugins.ui.mini-files" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = {},
  checker = { enabled = false }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "matchit", -- I use vim-matchup
        "matchparen",
        "netrwPlugin", -- Vim builtin file explorer
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
