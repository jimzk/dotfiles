-- Override:
-- https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/plugins/treesitter.lua#L5C1-L6C39
local M = {
  "nvim-treesitter/nvim-treesitter",
}

local highlight_disabled_langs = { "rust", "lua" }
local opts = {
  -- ensure_installed = "all",
  indent = { enable = true },
  -- NOTE: highlight affects performance significantly
  highlight = {
    enable = true,
    disable = function(lang, buf)
      if vim.tbl_contains(highlight_disabled_langs, lang) then
        return true
      end
      local max_filesize_in_kb = 10 -- In KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize_in_kb * 1024 then
        return true
      end
    end,
  },
  incremental_selection = {
    enable = false,
    keymaps = {
      init_selection = false,
      node_incremental = "<cr>",
      node_decremental = "<bs>",
      scope_incremental = false,
    },
  },
}

M.opts = function()
  return opts
end

return M
