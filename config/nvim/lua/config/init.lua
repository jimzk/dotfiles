---@type LazyVimConfig
local M = {}

M.lazy_version = ">=9.1.0"

---@class LazyVimConfig
local defaults = {
  -- colorscheme can be a string like `catppuccin` or a function that will load the colorscheme
  ---@type string|fun()
  colorscheme = function()
    -- require("tokyonight").load()
    require("catppuccin").load()
    -- Tiny modify
    vim.cmd [[hi Comment guifg=#6b6f8c]] -- Lighter comment
  end,
  -- icons used by other plugins
  icons = {
    diagnostics = {
      Error = " ",
      Warn = " ",
      Hint = " ",
      Info = " ",
    },
    git = {
      added = " ",
      modified = " ",
      removed = " ",
    },
  },
}

---@type LazyVimConfig
local options

---@param opts? LazyVimConfig
function M.setup(opts)
  require("config.lazy")
  options = vim.tbl_deep_extend("force", defaults, opts or {})
  if not M.has() then
    require("lazy.core.util").error(
      "**LazyVim** needs **lazy.nvim** version "
      .. M.lazy_version
      .. " to work properly.\n"
      .. "Please upgrade **lazy.nvim**",
      { title = "LazyVim" }
    )
  end

  if vim.fn.argc() == 0 then
    -- autocmds and keymaps can wait to load
    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup("LazyVim", { clear = true }),
      pattern = "VeryLazy",
      callback = function()
        M.load("autocmds")
        M.load("keymaps")
        M.load("abbrev")
        M.load("improvement")
      end,
    })
  else
    -- load them now so they affect the opened buffers
    M.load("autocmds")
    M.load("keymaps")
    M.load("abbrev")
    M.load("improvement")
  end

  require("lazy.core.util").try(function()
    if type(M.colorscheme) == "function" then
      M.colorscheme()
    else
      vim.cmd.colorscheme(M.colorscheme)
    end
  end, {
    msg = "Could not load your colorscheme",
    on_error = function(msg)
      require("lazy.core.util").error(msg)
      vim.cmd.colorscheme("habamax")
    end,
  })
end

---@param range? string
function M.has(range)
  local Semver = require("lazy.manage.semver")
  return Semver.range(range or M.lazy_version):matches(require("lazy.core.config").version or "0.0.0")
end

---@param name "autocmds" | "options" | "keymaps" | "improvement" | "abbrev"
function M.load(name)
  local lazy_util = require("lazy.core.util")
  -- always load lazyvim, then user file
  local mod = "config." .. name
  lazy_util.try(function()
    require(mod)
  end, {
    msg = "Failed loading " .. mod,
    on_error = function(msg)
      lazy_util.error(msg)
    end,
  })
  if vim.bo.filetype == "lazy" then
    -- HACK: LazyVim may have overwritten options of the Lazy ui, so reset this here
    vim.cmd([[do VimResized]])
  end
end

M.did_init = false
function M.init()
  if not M.did_init then
    M.did_init = true
    -- delay notifications till vim.notify was replaced or after 500ms
    Util.lazy_notify()

    -- load options here, before lazy init while sourcing plugin modules
    -- this is needed to make sure options will be correctly applied
    -- after installing missing plugins
    require("config").load("options")
  end
end

setmetatable(M, {
  __index = function(_, key)
    if options == nil then
      M.setup()
    end
    ---@cast options LazyVimConfig
    return options[key]
  end,
})

return M
