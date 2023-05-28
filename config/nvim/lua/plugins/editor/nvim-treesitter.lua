local M = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "BufReadPost",
}

local incremental_selection_key = "<cr>"
local decremental_selection_key = "<bs>"
local highlight_disabled_langs = { "", "gitcommit", "markdown" }
M.opts = {
  ensure_installed = "all",
  -- https://www.reddit.com/r/neovim/comments/1144spy/comment/j8vpwey
  ignore_install = { "comment" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    disable = function(lang, buf)
      if vim.tbl_contains(highlight_disabled_langs, lang) then
        return true
      end
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },
  indent = {
    enable = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<cr>",
      node_incremental = "<cr>",
      node_decremental = "<bs>",
      scope_incremental = false, -- '<TAB>'
    },
  },
}

M.config = function(_, opts)
  require("nvim-treesitter.configs").setup(opts)
  -- map init_selection by manual for position mark
  -- map("n", incremental_selection_key, function()
  --   vim.cmd([[normal! mv]]) -- init range selection
  --   require("nvim-treesitter.incremental_selection").init_selection()
  -- end, "incremental selection")
end

return M
