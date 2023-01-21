local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    { "folke/lazy.nvim" },
    { import = "plugins" },
    -- import any extras modules here
    -- { import = "plugins.extras.lang.typescript" },
    -- { imporlt = "plugins.extras.lang.json" },
  },
  defaults = {
    lazy = true, -- every plugin is lazy-loaded by default
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  checker = { enabled = false }, -- automatically check for plugin updates
  performance = {
    -- cache = {
    --   disable_events = { "BufReadPost" },
    -- },
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        -- https://github.com/CKolkey/config/blob/master/nvim/lua/config/options.lua#L59
        "2html_plugin",
        "getscript",
        "getscriptPlugin",
        "logiPat",
        "netrw",
        "netrwFileHandlers",
        "netrwSettings",
        "rrhelper",
        "tar",
        "vimball",
        "vimballPlugin",
        "zip",
      },
    },
  },
})
